open! Stdune
open Import

let wait_for_server common =
  match (Dune_rpc_impl.Where.get (), Common.rpc common) with
  | None, None -> User_error.raise [ Pp.text "rpc server not running" ]
  | Some p, Some _ ->
    User_error.raise
      [ Pp.textf "cannot start rpc. It's already running at %s"
          (Dune_rpc.Where.to_string p)
      ]
  | Some w, None -> w
  | None, Some _ ->
    User_error.raise [ Pp.text "failed to establish rpc connection " ]

let client_term common f =
  let common = Common.set_print_directory common false in
  let config = Common.init ~log_file:No_log_file common in
  Scheduler.go ~common ~config (fun () -> f common)

(* cwong: Should we put this into [dune-rpc]? *)
let interpret_kind = function
  | Dune_rpc_private.Response.Error.Invalid_request -> "Invalid_request"
  | Code_error -> "Code_error"

let raise_rpc_error (e : Dune_rpc_private.Response.Error.t) =
  User_error.raise
    [ Pp.text "Server returned error: "
    ; Pp.textf "%s (error kind: %s)" e.message (interpret_kind e.kind)
    ]

let request_exn client witness n =
  let open Fiber.O in
  let* decl = Dune_rpc_impl.Client.Versioned.prepare_request client witness in
  match decl with
  | Error e -> raise (Dune_rpc_private.Version_error.E e)
  | Ok decl -> Dune_rpc_impl.Client.request client decl n

let retry_loop once =
  let open Fiber.O in
  let rec loop () =
    let* res = once () in
    match res with
    | Some result -> Fiber.return result
    | None ->
      let* () = Scheduler.sleep 0.2 in
      loop ()
  in
  loop ()

let establish_connection_or_raise ~wait ~common once =
  let open Fiber.O in
  if wait then
    retry_loop once
  else
    let+ res = once () in
    match res with
    | Some (client, session) -> (client, session)
    | None ->
      let (_ : Dune_rpc_private.Where.t) = wait_for_server common in
      User_error.raise
        [ Pp.text
            "failed to establish connection even though server seems to be \
             running"
        ]

let wait_term =
  let doc =
    "poll until server starts listening and then establish connection."
  in
  Arg.(value & flag & info [ "wait" ] ~doc)

let establish_client_session ~common ~wait =
  let open Fiber.O in
  let once () =
    let where = Dune_rpc_impl.Where.get () in
    match where with
    | None -> Fiber.return None
    | Some where -> (
      let* client = Dune_rpc_impl.Run.Connect.csexp_client where in
      let+ session = Csexp_rpc.Client.connect client in
      match session with
      | Ok session -> Some (client, session)
      | Error exn ->
        Console.print
          [ Pp.text "failed to connect:"; Exn_with_backtrace.pp exn ];
        None)
  in
  establish_connection_or_raise ~wait ~common once

module Init = struct
  let connect ~wait common =
    Dune_util.Log.init ~file:No_log_file ();
    let open Fiber.O in
    let* client, session = establish_client_session ~common ~wait in
    let* stdio = Csexp_rpc.Session.create ~socket:false stdin stdout in
    let forward f t =
      Fiber.repeat_while ~init:() ~f:(fun () ->
          let* read = Csexp_rpc.Session.read f in
          let+ () =
            Csexp_rpc.Session.write t (Option.map read ~f:List.singleton)
          in
          Option.map read ~f:(fun (_ : Sexp.t) -> ()))
    in
    Fiber.finalize
      (fun () ->
        Fiber.fork_and_join_unit
          (fun () -> forward session stdio)
          (fun () -> forward stdio session))
      ~finally:(fun () ->
        Csexp_rpc.Client.stop client;
        Fiber.return ())

  let term =
    let+ (common : Common.t) = Common.term
    and+ wait = wait_term in
    client_term common (connect ~wait)

  let man = [ `Blocks Common.help_secs ]

  let doc = "establish a new rpc connection"

  let info = Term.info "init" ~doc ~man

  let term = (Term.Group.Term term, info)
end

let report_error error =
  Printf.printf "Error: %s\n%!"
    (Dyn.to_string (Dune_rpc_private.Response.Error.to_dyn error))

let witness = Dune_rpc_private.Decl.Request.witness

module Status = struct
  let term =
    let+ (common : Common.t) = Common.term in
    client_term common @@ fun common ->
    let where = wait_for_server common in
    printfn "Server is listening on %s" (Dune_rpc.Where.to_string where);
    printfn "Connected clients (including this one):\n";
    Dune_rpc_impl.Run.client where
      (Dune_rpc.Initialize.Request.create
         ~id:(Dune_rpc.Id.make (Sexp.Atom "status")))
      ~f:(fun session ->
        let open Fiber.O in
        let+ response =
          request_exn session (witness Dune_rpc_impl.Decl.status) ()
        in
        match response with
        | Error error -> report_error error
        | Ok { clients } ->
          List.iter clients ~f:(fun (client, menu) ->
              let id =
                let sexp = Dune_rpc.Conv.to_sexp Dune_rpc.Id.sexp client in
                Sexp.to_string sexp
              in
              let message =
                match (menu : Dune_rpc_impl.Decl.Status.Menu.t) with
                | Uninitialized ->
                  User_message.make
                    [ Pp.textf "Client [%s], conducting version negotiation" id
                    ]
                | Menu menu ->
                  User_message.make
                    [ Pp.box ~indent:2
                        (Pp.concat ~sep:Pp.newline
                           (Pp.textf
                              "Client [%s] with the following RPC versions:" id
                           :: List.map menu ~f:(fun (method_, version) ->
                                  Pp.textf "%s: %d" method_ version)))
                    ]
              in
              User_message.print message))

  let info =
    let doc = "show active connections" in
    Term.info "status" ~doc

  let term = (Term.Group.Term term, info)
end

module Build = struct
  let term =
    let name_ = Arg.info [] ~docv:"TARGET" in
    let+ (common : Common.t) = Common.term
    and+ wait = wait_term
    and+ targets = Arg.(value & pos_all string [] name_) in
    client_term common @@ fun common ->
    let open Fiber.O in
    let* _client, session = establish_client_session ~common ~wait in
    Dune_rpc_impl.Run.client_with_session ~session
      (Dune_rpc.Initialize.Request.create
         ~id:(Dune_rpc.Id.make (Sexp.Atom "build")))
      ~f:(fun session ->
        let open Fiber.O in
        let+ response =
          request_exn session (witness Dune_rpc_impl.Decl.build) targets
        in
        match response with
        | Error (error : Dune_rpc_private.Response.Error.t) ->
          report_error error
        | Ok Failure -> print_endline "Failure"
        | Ok Success -> print_endline "Success")

  let info =
    let doc =
      "build a given target (requires dune to be running in passive watching \
       mode)"
    in
    Term.info "build" ~doc

  let term = (Term.Group.Term term, info)
end

module Ping = struct
  let send_ping cli =
    let open Fiber.O in
    let+ response = request_exn cli Dune_rpc_private.Public.Request.ping () in
    match response with
    | Ok () ->
      User_message.print
        (User_message.make
           [ Pp.text "Server appears to be responding normally" ])
    | Error e -> raise_rpc_error e

  let exec common =
    let where = wait_for_server common in
    Dune_rpc_impl.Run.client where
      (Dune_rpc_private.Initialize.Request.create
         ~id:(Dune_rpc_private.Id.make (Sexp.Atom "ping_cmd")))
      ~f:send_ping

  let info =
    let doc = "Ping the build server running in the current directory" in
    Term.info "ping" ~doc

  let term =
    let+ (common : Common.t) = Common.term in
    client_term common exec

  let term = (Term.Group.Term term, info)
end

let info =
  let doc = "Dune's RPC mechanism. Experimental." in
  let man =
    [ `S "DESCRIPTION"
    ; `P {|This is experimental. do not use|}
    ; `Blocks Common.help_secs
    ]
  in
  Term.info "rpc" ~doc ~man

let group =
  (Term.Group.Group [ Init.term; Status.term; Build.term; Ping.term ], info)
