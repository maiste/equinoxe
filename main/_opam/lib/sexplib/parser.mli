type token =
  | STRING of (string)
  | LPAREN
  | RPAREN
  | EOF
  | HASH_SEMI

val sexp :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Type.t
val sexp_opt :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Type.t option
val sexps :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Type.t list
val rev_sexps :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Type.t list
