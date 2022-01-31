open Stdune

let dyn_of_pp tag pp =
  let open Dyn.Encoder in
  let rec conv = function
    | Pp.Ast.Nop -> constr "Nop" []
    | Seq (x, y) -> constr "Seq" [ conv x; conv y ]
    | Concat (x, y) -> constr "Concat" [ conv x; list conv y ]
    | Box (i, x) -> constr "Box" [ int i; conv x ]
    | Vbox (i, x) -> constr "Vbox" [ int i; conv x ]
    | Hbox x -> constr "Hbox" [ conv x ]
    | Hvbox (i, x) -> constr "Hvbox" [ int i; conv x ]
    | Hovbox (i, x) -> constr "Hovbox" [ int i; conv x ]
    | Verbatim s -> constr "Verbatim" [ string s ]
    | Char c -> constr "Char" [ char c ]
    | Break (x, y) ->
      let f = triple string int string in
      constr "Break" [ f x; f y ]
    | Newline -> constr "Newline" []
    | Tag (ta, t) -> constr "Tag" [ tag ta; conv t ]
    | Text s -> constr "Text" [ string s ]
  in
  conv
    (match Pp.to_ast pp with
    | Ok s -> s
    | Error () -> assert false)

let%expect_test "reproduce #2664" =
  (* https://github.com/ocaml/dune/issues/2664 *)
  let b = Buffer.create 100 in
  let f s = Buffer.add_string b ("\027[34m" ^ s ^ "\027[39m") in
  for i = 1 to 20 do
    f (string_of_int i)
  done;
  let string_with_ansi_colors = Buffer.contents b in
  let pp = Ansi_color.parse string_with_ansi_colors in
  let ansi_colors_from_pp =
    let b = Buffer.create 16 in
    let ppf = Format.formatter_of_buffer b in
    Staged.unstage (Ansi_color.make_printer (lazy true) ppf) pp;
    Buffer.contents b
  in
  printfn "Original : %S" string_with_ansi_colors;
  printfn "From PP  : %S" ansi_colors_from_pp;
  [%expect
    {|
    Original : "\027[34m1\027[39m\027[34m2\027[39m\027[34m3\027[39m\027[34m4\027[39m\027[34m5\027[39m\027[34m6\027[39m\027[34m7\027[39m\027[34m8\027[39m\027[34m9\027[39m\027[34m10\027[39m\027[34m11\027[39m\027[34m12\027[39m\027[34m13\027[39m\027[34m14\027[39m\027[34m15\027[39m\027[34m16\027[39m\027[34m17\027[39m\027[34m18\027[39m\027[34m19\027[39m\027[34m20\027[39m"
    From PP  : "\027[34m1\027[0m\027[34m2\027[0m\027[34m3\027[0m\027[34m4\027[0m\027[34m5\027[0m\027[34m6\027[0m\027[34m7\027[0m\027[34m8\027[0m\027[34m9\027[0m\027[34m10\027[0m\027[34m11\027[0m\027[34m12\027[0m\027[34m13\027[0m\027[34m14\027[0m\027[34m15\027[0m\027[34m16\027[0m\027[34m17\027[0m\027[34m18\027[0m\027[34m19\027[0m\027[34m20\027[0m" |}];
  let pp = dyn_of_pp (Dyn.Encoder.list Ansi_color.Style.to_dyn) pp |> Dyn.pp in
  Format.printf "%a@.%!" Pp.to_fmt pp;
  [%expect
    {|
    Vbox
      0,Seq
          Seq
            Seq
              Seq
                Seq
                  Seq
                    Seq
                      Seq
                        Seq
                          Seq
                            Seq
                              Seq
                                Seq
                                  Seq
                                    Seq
                                      Seq
                                        Seq
                                          Seq
                                            Seq
                                              Seq Nop,Tag [ "34" ],Verbatim "1",
                                              Tag
                                                [ "34" ],Verbatim "2",Tag
                                                                        [ "34" ],
                                                                        Verbatim
                                                                        "3",
                                          Tag
                                            [ "34" ],Verbatim "4",Tag
                                                                    [ "34" ],
                                                                    Verbatim
                                                                      "5",
                                      Tag
                                        [ "34" ],Verbatim "6",Tag
                                                                [ "34" ],
                                                                Verbatim
                                                                  "7",Tag
                                                                        [ "34" ],
                                                                        Verbatim
                                                                        "8",
                                Tag
                                  [ "34" ],Verbatim "9",Tag
                                                          [ "34" ],Verbatim "10",
                            Tag
                              [ "34" ],Verbatim "11",Tag [ "34" ],Verbatim "12",
                        Tag
                          [ "34" ],Verbatim "13",Tag [ "34" ],Verbatim "14",
                    Tag
                      [ "34" ],Verbatim "15",Tag [ "34" ],Verbatim "16",Tag
                                                                        [ "34" ],
                                                                        Verbatim
                                                                        "17",
              Tag
                [ "34" ],Verbatim "18",Tag [ "34" ],Verbatim "19",Tag
                                                                    [ "34" ],
                                                                    Verbatim
                                                                      "20" |}]
