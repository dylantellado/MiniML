
(* The type of tokens. *)

type token = 
  | TRUE
  | TIMES
  | THEN
  | REC
  | RANDINT
  | RANDFLOAT
  | RAISE
  | PLUS
  | OPEN
  | NEG
  | MINUS
  | LET
  | LESSTHAN
  | INT of (int)
  | IN
  | IF
  | ID of (string)
  | GREATERTHAN
  | FUNCTION
  | FLTIMES
  | FLPLUS
  | FLOAT of (float)
  | FLMINUS
  | FLEXPONENT
  | FLDIVIDE
  | FALSE
  | FACTORIAL
  | EXPONENT
  | EQUALS
  | EOF
  | ELSE
  | DOT
  | DIVIDE
  | CLOSE
  | CHOOSE

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val input: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Expr.expr)
