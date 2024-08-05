# 7 "miniml_lex.mll"
 
  open Printf ;;
  open Miniml_parse ;; (* need access to parser's token definitions *)

  let create_hashtable size init =
    let tbl = Hashtbl.create size in
    List.iter (fun (key, data) -> Hashtbl.add tbl key data) init;
    tbl

  let keyword_table = 
    create_hashtable 8 [
                       ("if", IF);
                       ("in", IN);
                       ("then", THEN);
                       ("else", ELSE);
                       ("let", LET);
                       ("raise", RAISE);
                       ("randint", RANDINT);
                       ("randfloat", RANDFLOAT);
                       ("choose", CHOOSE);
                       ("rec", REC);
                       ("true", TRUE);
                       ("false", FALSE);
                       ("fun", FUNCTION);
                       ("function", FUNCTION)
                     ]
                     
  let sym_table = 
    create_hashtable 8 [
                       ("=", EQUALS);
                       ("<", LESSTHAN);
                       (">", GREATERTHAN);
                       (".", DOT);
                       ("->", DOT);
                       (";;", EOF);
                       ("~-", NEG);
                       ("!", FACTORIAL);
                       ("+", PLUS);
                       ("-", MINUS);
                       ("*", TIMES);
                       ("^", EXPONENT);
                       ("/", DIVIDE);
                       ("(", OPEN);
                       (")", CLOSE);
                       ("+.", FLPLUS);
                       ("-.", FLMINUS);
                       ("*.", FLTIMES);
                       ("/.", FLDIVIDE);
                       ("**", FLEXPONENT);
                     ]

# 54 "miniml_lex.ml"
let __ocaml_lex_tables = {
  Lexing.lex_base =
   "\000\000\248\255\249\255\250\255\002\000\095\000\252\255\095\000\
    \018\000\028\000\004\000\009\000";
  Lexing.lex_backtrk =
   "\255\255\255\255\255\255\255\255\006\000\003\000\255\255\002\000\
    \000\000\001\000\255\255\004\000";
  Lexing.lex_default =
   "\002\000\000\000\000\000\000\000\010\000\255\255\000\000\255\255\
    \255\255\255\255\010\000\010\000";
  Lexing.lex_trans =
   "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\003\000\003\000\000\000\255\255\000\000\255\255\000\000\
    \000\000\000\000\000\000\255\255\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \003\000\005\000\000\000\005\000\005\000\005\000\005\000\000\000\
    \006\000\006\000\005\000\005\000\000\000\005\000\005\000\005\000\
    \008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\005\000\005\000\005\000\005\000\005\000\005\000\
    \009\000\000\000\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\009\000\009\000\009\000\009\000\
    \009\000\009\000\009\000\009\000\009\000\009\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\005\000\000\000\
    \000\000\007\000\007\000\007\000\007\000\007\000\007\000\007\000\
    \007\000\007\000\007\000\007\000\007\000\007\000\007\000\007\000\
    \007\000\007\000\007\000\007\000\007\000\007\000\007\000\007\000\
    \007\000\007\000\007\000\004\000\000\000\000\000\005\000\011\000\
    \005\000\011\000\005\000\005\000\005\000\005\000\011\000\000\000\
    \000\000\005\000\005\000\000\000\005\000\005\000\005\000\007\000\
    \007\000\007\000\007\000\007\000\007\000\007\000\007\000\007\000\
    \007\000\005\000\005\000\005\000\005\000\005\000\005\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\005\000\000\000\000\000\
    \007\000\007\000\007\000\007\000\007\000\007\000\007\000\007\000\
    \007\000\007\000\007\000\007\000\007\000\007\000\007\000\007\000\
    \007\000\007\000\007\000\007\000\007\000\007\000\007\000\007\000\
    \007\000\007\000\000\000\000\000\000\000\005\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \001\000\000\000\255\255\000\000\255\255\000\000\000\000\000\000\
    \000\000\255\255\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    ";
  Lexing.lex_check =
   "\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\000\000\000\000\255\255\004\000\255\255\010\000\255\255\
    \255\255\255\255\255\255\011\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\000\000\255\255\000\000\000\000\000\000\000\000\255\255\
    \000\000\000\000\000\000\000\000\255\255\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \008\000\255\255\008\000\008\000\008\000\008\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\009\000\009\000\009\000\009\000\
    \009\000\009\000\009\000\009\000\009\000\009\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\000\000\255\255\
    \255\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\255\255\255\255\000\000\004\000\
    \005\000\010\000\005\000\005\000\005\000\005\000\011\000\255\255\
    \255\255\005\000\005\000\255\255\005\000\005\000\005\000\007\000\
    \007\000\007\000\007\000\007\000\007\000\007\000\007\000\007\000\
    \007\000\005\000\005\000\005\000\005\000\005\000\005\000\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\005\000\255\255\255\255\
    \007\000\007\000\007\000\007\000\007\000\007\000\007\000\007\000\
    \007\000\007\000\007\000\007\000\007\000\007\000\007\000\007\000\
    \007\000\007\000\007\000\007\000\007\000\007\000\007\000\007\000\
    \007\000\007\000\255\255\255\255\255\255\005\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\255\255\004\000\255\255\010\000\255\255\255\255\255\255\
    \255\255\011\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    ";
  Lexing.lex_base_code =
   "";
  Lexing.lex_backtrk_code =
   "";
  Lexing.lex_default_code =
   "";
  Lexing.lex_trans_code =
   "";
  Lexing.lex_check_code =
   "";
  Lexing.lex_code =
   "";
}

let rec token lexbuf =
   __ocaml_lex_token_rec lexbuf 0
and __ocaml_lex_token_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
let
# 65 "miniml_lex.mll"
              inum
# 179 "miniml_lex.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 66 "miniml_lex.mll"
        ( let num = int_of_string inum in
          INT num
        )
# 185 "miniml_lex.ml"

  | 1 ->
let
# 69 "miniml_lex.mll"
                         fnum
# 191 "miniml_lex.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 70 "miniml_lex.mll"
      ( let flt = float_of_string fnum in
        FLOAT flt
      )
# 197 "miniml_lex.ml"

  | 2 ->
let
# 73 "miniml_lex.mll"
          word
# 203 "miniml_lex.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 74 "miniml_lex.mll"
        ( try
            let token = Hashtbl.find keyword_table word in
            token 
          with Not_found ->
            ID word
        )
# 212 "miniml_lex.ml"

  | 3 ->
let
# 80 "miniml_lex.mll"
           symbol
# 218 "miniml_lex.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 81 "miniml_lex.mll"
        ( try
            let token = Hashtbl.find sym_table symbol in
            token
          with Not_found ->
            printf "Ignoring unrecognized token: %s\n" symbol;
            token lexbuf
        )
# 228 "miniml_lex.ml"

  | 4 ->
# 88 "miniml_lex.mll"
                        ( token lexbuf )
# 233 "miniml_lex.ml"

  | 5 ->
# 89 "miniml_lex.mll"
                        ( token lexbuf )
# 238 "miniml_lex.ml"

  | 6 ->
let
# 90 "miniml_lex.mll"
         c
# 244 "miniml_lex.ml"
= Lexing.sub_lexeme_char lexbuf lexbuf.Lexing.lex_start_pos in
# 91 "miniml_lex.mll"
        ( printf "Ignoring unrecognized character: %c\n" c;
          token lexbuf
        )
# 250 "miniml_lex.ml"

  | 7 ->
# 95 "miniml_lex.mll"
        ( raise End_of_file )
# 255 "miniml_lex.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_token_rec lexbuf __ocaml_lex_state

;;
