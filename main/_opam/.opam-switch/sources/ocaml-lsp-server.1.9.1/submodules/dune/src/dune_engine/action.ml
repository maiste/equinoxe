open! Stdune
open Import
module Outputs = Action_ast.Outputs
module Inputs = Action_ast.Inputs

module File_perm = struct
  include Action_intf.File_perm

  let to_unix_perm = function
    | Normal -> 0o666
    | Executable -> 0o777
end

module Prog = struct
  module Not_found = struct
    type t =
      { context : Context_name.t
      ; program : string
      ; hint : string option
      ; loc : Loc.t option
      }

    let create ?hint ~context ~program ~loc () = { hint; context; program; loc }

    let user_message { context; program; hint; loc } =
      let hint =
        match program with
        | "refmt" -> Some (Option.value ~default:"opam install reason" hint)
        | _ -> hint
      in
      Utils.program_not_found_message ?hint ~loc ~context program

    let raise t = raise (User_error.E (user_message t, []))

    let to_dyn { context; program; hint; loc = _ } =
      let open Dyn.Encoder in
      record
        [ ("context", Context_name.to_dyn context)
        ; ("program", string program)
        ; ("hint", option string hint)
        ]
  end

  type t = (Path.t, Not_found.t) result

  let decode : t Dune_lang.Decoder.t =
    Dune_lang.Decoder.map Dpath.decode ~f:Result.ok

  let encode = function
    | Ok s -> Dpath.encode s
    | Error (e : Not_found.t) -> Dune_lang.Encoder.string e.program

  let to_dyn t = Result.to_dyn Path.to_dyn Not_found.to_dyn t

  let ok_exn = function
    | Ok s -> s
    | Error e -> Not_found.raise e
end

module type Ast =
  Action_intf.Ast
    with type program = Prog.t
    with type path = Path.t
    with type target = Path.Build.t
    with type string = String.t

module rec Ast : Ast = Ast

module String_with_sexp = struct
  type t = string

  let decode = Dune_lang.Decoder.string

  let encode = Dune_lang.Encoder.string

  let is_dev_null s = Path.equal (Path.of_string s) Config.dev_null
end

include Action_ast.Make (Prog) (Dpath) (Dpath.Build) (String_with_sexp) (Ast)

type path = Path.t

type target = Path.Build.t

type string = String.t

module For_shell = struct
  module type Ast =
    Action_intf.Ast
      with type program = string
      with type path = string
      with type target = string
      with type string = string

  module rec Ast : Ast = Ast

  include
    Action_ast.Make (String_with_sexp) (String_with_sexp) (String_with_sexp)
      (String_with_sexp)
      (Ast)
end

module Relativise = Action_mapper.Make (Ast) (For_shell.Ast)

let for_shell t =
  let rec loop t ~dir ~f_program ~f_string ~f_path ~f_target =
    match t with
    | Symlink (src, dst) ->
      let src =
        match Path.Build.parent dst with
        | None -> Path.to_string src
        | Some from -> Path.reach ~from:(Path.build from) src
      in
      let dst = Path.reach ~from:dir (Path.build dst) in
      For_shell.Symlink (src, dst)
    | t ->
      Relativise.map_one_step loop t ~dir ~f_program ~f_string ~f_path ~f_target
  in
  loop t ~dir:Path.root
    ~f_string:(fun ~dir:_ x -> x)
    ~f_path:(fun ~dir x -> Path.reach x ~from:dir)
    ~f_target:(fun ~dir x -> Path.reach (Path.build x) ~from:dir)
    ~f_program:(fun ~dir x ->
      match x with
      | Ok p -> Path.reach p ~from:dir
      | Error e -> e.program)

let fold_one_step t ~init:acc ~f =
  match t with
  | Chdir (_, t)
  | Setenv (_, _, t)
  | Redirect_out (_, _, _, t)
  | Redirect_in (_, _, t)
  | Ignore (_, t)
  | With_accepted_exit_codes (_, t)
  | No_infer t ->
    f acc t
  | Progn l
  | Pipe (_, l) ->
    List.fold_left l ~init:acc ~f
  | Run _
  | Dynamic_run _
  | Echo _
  | Cat _
  | Copy _
  | Symlink _
  | Hardlink _
  | Copy_and_add_line_directive _
  | System _
  | Bash _
  | Write_file _
  | Rename _
  | Remove_tree _
  | Mkdir _
  | Diff _
  | Merge_files_into _
  | Cram _
  | Format_dune_file _ ->
    acc

include Action_mapper.Make (Ast) (Ast)

let chdirs =
  let rec loop acc t =
    let acc =
      match t with
      | Chdir (dir, _) -> Path.Set.add acc dir
      | _ -> acc
    in
    fold_one_step t ~init:acc ~f:loop
  in
  fun t -> loop Path.Set.empty t

let empty = Progn []

let rec is_dynamic = function
  | Dynamic_run _ -> true
  | Chdir (_, t)
  | Setenv (_, _, t)
  | Redirect_out (_, _, _, t)
  | Redirect_in (_, _, t)
  | Ignore (_, t)
  | With_accepted_exit_codes (_, t)
  | No_infer t ->
    is_dynamic t
  | Progn l
  | Pipe (_, l) ->
    List.exists l ~f:is_dynamic
  | Run _
  | System _
  | Bash _
  | Echo _
  | Cat _
  | Copy _
  | Symlink _
  | Hardlink _
  | Copy_and_add_line_directive _
  | Write_file _
  | Rename _
  | Remove_tree _
  | Diff _
  | Mkdir _
  | Merge_files_into _
  | Cram _
  | Format_dune_file _ ->
    false

let prepare_managed_paths ~link ~sandboxed deps =
  let steps =
    Path.Map.foldi deps ~init:[] ~f:(fun path _ acc ->
        match Path.as_in_build_dir path with
        | None ->
          (* This can actually raise if we try to sandbox the "copy from source
             dir" rules. There is no reason to do that though. *)
          if Path.is_in_source_tree path then
            Code_error.raise
              "Action depends on source tree. All actions should depend on the \
               copies in build directory instead"
              [ ("path", Path.to_dyn path) ];
          acc
        | Some p -> link path (sandboxed p) :: acc)
  in
  Progn steps

let link_function ~(mode : Sandbox_mode.some) : path -> target -> t =
  let win32_error mode =
    let mode = Sandbox_mode.to_string (Some mode) in
    Code_error.raise
      (sprintf
         "Don't have %ss on win32, but [%s] sandboxing mode was selected. To \
          use emulation via copy, the [copy] sandboxing mode should be \
          selected."
         mode mode)
      []
  in
  match mode with
  | Symlink -> (
    match Sys.win32 with
    | true -> win32_error mode
    | false -> fun a b -> Symlink (a, b))
  | Copy -> fun a b -> Copy (a, b)
  | Hardlink -> (
    match Sys.win32 with
    | true -> win32_error mode
    | false -> fun a b -> Hardlink (a, b))

let maybe_sandbox_path f p =
  match Path.as_in_build_dir p with
  | None -> p
  | Some p -> Path.build (f p)

let sandbox t ~sandboxed ~mode ~deps : t =
  let link = link_function ~mode in
  Progn
    [ prepare_managed_paths ~sandboxed ~link deps
    ; map t ~dir:Path.root
        ~f_string:(fun ~dir:_ x -> x)
        ~f_path:(fun ~dir:_ p -> maybe_sandbox_path sandboxed p)
        ~f_target:(fun ~dir:_ -> sandboxed)
        ~f_program:(fun ~dir:_ -> Result.map ~f:(maybe_sandbox_path sandboxed))
    ]

type is_useful =
  | Clearly_not
  | Maybe

let is_useful_to distribute memoize =
  let rec loop t =
    match t with
    | Chdir (_, t) -> loop t
    | Setenv (_, _, t) -> loop t
    | Redirect_out (_, _, _, t) -> memoize || loop t
    | Redirect_in (_, _, t) -> loop t
    | Ignore (_, t)
    | With_accepted_exit_codes (_, t)
    | No_infer t ->
      loop t
    | Progn l
    | Pipe (_, l) ->
      List.exists l ~f:loop
    | Echo _ -> false
    | Cat _ -> memoize
    | Copy _ -> memoize
    | Symlink _ -> false
    | Hardlink _ -> false
    | Copy_and_add_line_directive _ -> memoize
    | Write_file _ -> distribute
    | Rename _ -> memoize
    | Remove_tree _ -> false
    | Diff _ -> distribute
    | Mkdir _ -> false
    | Merge_files_into _ -> distribute
    | Cram _
    | Run _ ->
      true
    | Dynamic_run _ -> true
    | System _ -> true
    | Bash _ -> true
    | Format_dune_file _ -> memoize
  in
  fun t ->
    match loop t with
    | true -> Maybe
    | false -> Clearly_not

let is_useful_to_sandbox = is_useful_to false false

let is_useful_to_distribute = is_useful_to true false

let is_useful_to_memoize = is_useful_to true true

module Full = struct
  type nonrec t =
    { action : t
    ; env : Env.t
    ; locks : Path.t list
    ; can_go_in_shared_cache : bool
    }
end
