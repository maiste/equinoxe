type token =
  | EOF
  | EOL
  | SPACE
  | SNAMESERVER
  | DOT
  | COLON
  | IPV4 of (string)
  | IPV6 of (string)

val resolvconf :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> [ `Nameserver of Ipaddr.t ] list
