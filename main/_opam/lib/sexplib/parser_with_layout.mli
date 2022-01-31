type token =
  | STRING of (string * (Lexing.position * string) option)
  | COMMENT of (string * Lexing.position option)
  | LPAREN
  | RPAREN
  | EOF
  | HASH_SEMI

val sexp :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Type_with_layout.t_or_comment
val sexp_opt :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Type_with_layout.t_or_comment option
val sexps :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Type_with_layout.t_or_comment list
val sexps_abs :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Type_with_layout.Parsed.t_or_comment list
val rev_sexps :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Type_with_layout.t_or_comment list
