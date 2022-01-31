module List = ListLabels

type warning =
  { code : int option
  ; name : string option
  }

type severity =
  | Error
  | Warning of warning

type message =
  | Raw of string
  | Structured of
      { file_excerpt : string option
      ; message : string
      ; severity : severity
      }

type loc =
  { path : string
  ; line : [ `Single of int | `Range of int * int ]
  ; chars : (int * int) option
  }

type report =
  { loc : loc
  ; message : message
  ; related : (loc * message) list
  }

let re =
  lazy
    (let open Re in
    let path = rep (compl [ char '"' ]) in
    let number = group (rep1 digit) in
    let range = seq [ number; char '-'; number ] in
    let chars = seq [ str "characters"; rep1 space; range ] in
    let file = seq [ str "File "; char '"'; group path; char '"'; char ',' ] in
    let single_marker, line = mark (seq [ str "line"; rep1 space; number ]) in
    let lines = seq [ str "lines"; rep1 space; range ] in
    let related_marker, related_space = mark (seq [ char '\n'; rep1 blank ]) in
    let re =
      seq
        [ opt related_space
        ; file
        ; rep1 space
        ; alt [ line; lines ]
        ; opt (seq [ char ','; rep1 space; chars ])
        ; char ':'
        ; rep space
        ]
    in
    (Re.compile re, single_marker, related_marker))

let message_re =
  lazy
    (let open Re in
    let error_marker, error = mark (str "Error") in
    let warning =
      seq
        [ str "Warning "
        ; opt
            (seq
               [ group (rep1 digit)
               ; seq
                   [ rep1 space
                   ; char '['
                   ; group (rep1 (compl [ char ']' ]))
                   ; char ']'
                   ]
               ])
        ]
    in
    let severity = seq [ alt [ bol; bos ]; alt [ error; warning ]; char ':' ] in
    let re =
      seq
        [ opt (group (rep1 any))
        ; severity
        ; rep space
        ; group (rep any)
        ; rep space
        ]
    in
    (compile re, error_marker))

let group_opt g i =
  if Re.Group.test g i then
    Some (Re.Group.get g i)
  else
    None

let parse_message msg =
  let re, error_marker = Lazy.force message_re in
  match Re.exec re msg with
  | exception Not_found -> Raw msg
  | group ->
    let file_excerpt = group_opt group 1 in
    let severity =
      if Re.Mark.test group error_marker then
        Error
      else
        let code = group_opt group 2 |> Option.map int_of_string in
        let name = group_opt group 3 in
        Warning { code; name }
    in
    Structured { file_excerpt; severity; message = Re.Group.get group 4 }

let parse_raw s =
  let re, single_marker, related_marker = Lazy.force re in
  Re.split_full re s
  |> List.map ~f:(function
       | `Text s -> `Message (parse_message s)
       | `Delim group ->
         let str_group = Re.Group.get group in
         let int_group i = int_of_string (str_group i) in
         let line =
           if Re.Mark.test group single_marker then
             `Single (int_group 2)
           else
             `Range (int_group 3, int_group 4)
         in
         let chars =
           if Re.Group.test group 5 then
             Some (int_group 5, int_group 6)
           else
             None
         in
         let loc = { path = str_group 1; line; chars } in
         let kind =
           if Re.Mark.test group related_marker then
             `Related
           else
             `Parent
         in
         `Loc (kind, loc))

let parse s =
  let rec loop acc current = function
    | [] -> current_to_acc acc current
    | `Loc (`Parent, loc) :: `Message message :: xs ->
      let acc = current_to_acc acc current in
      let current = `Accumulating { related = []; loc; message } in
      loop acc current xs
    | `Loc (`Related, loc) :: `Message message :: xs ->
      let current =
        match current with
        | `None -> assert false
        | `Accumulating p ->
          `Accumulating { p with related = (loc, message) :: p.related }
      in
      loop acc current xs
  and current_to_acc acc current =
    match current with
    | `None -> acc
    | `Accumulating p -> { p with related = List.rev p.related } :: acc
  in
  let components = parse_raw s in
  List.rev (loop [] `None components)
