
(* The type of tokens. *)

type token = 
  | SEMICOLON
  | PERCENT
  | OPEN
  | LT
  | INT of (int)
  | GT
  | EQ
  | EOF
  | DIRECTIVE of (char)
  | DASH
  | CLOSE
  | CHAR of (char)

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> ( Duration_private.O.t -> Duration_private.O.t -> string )
