type token =
  | STAR
  | SLASH
  | SEMI
  | COMMA
  | EQUAL
  | EOI
  | TOK of (string)
  | QS of (string)

val media_ranges :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> (Accept_types.media_range * Accept_types.p list) Accept_types.qlist
val charsets :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Accept_types.charset Accept_types.qlist
val encodings :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Accept_types.encoding Accept_types.qlist
val languages :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Accept_types.language Accept_types.qlist
