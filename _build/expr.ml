(* 
                         CS 51 Final Project
                        MiniML -- Expressions
*)

(*......................................................................
  Abstract syntax of MiniML expressions 
 *)

type unop =
  | Negate
  | Factorial
  | RandInt 
  | RandFloat 
;;
    
type binop =
  | Plus
  | Minus
  | Times
  | Divide
  | Exponent
  | Equals
  | LessThan
  | GreaterThan
  | FlPlus
  | FlMinus
  | FlTimes 
  | FlDivide
  | FlExponent
  | Choose

;;

type varid = string ;;
  
type expr =
  | Var of varid                         (* variables *)
  | Num of int
  | Float of float                           (* integers *)
  | Bool of bool                         (* booleans *)
  | Unop of unop * expr                  (* unary operators *)
  | Binop of binop * expr * expr         (* binary operators *)
  | Conditional of expr * expr * expr    (* if then else *)
  | Fun of varid * expr                  (* function definitions *)
  | Let of varid * expr * expr           (* local naming *)
  | Letrec of varid * expr * expr        (* recursive local naming *)
  | Raise                                (* exceptions *)
  | Unassigned                           (* (temporarily) unassigned *)
  | App of expr * expr                   (* function applications *)
;;
  
(*......................................................................
  Manipulation of variable names (varids) and sets of them
 *)

(* varidset -- Sets of varids *)
module SS = Set.Make (struct
                       type t = varid
                       let compare = String.compare
                     end ) ;;

type varidset = SS.t ;;

(* same_vars varids1 varids2 -- Tests to see if two `varid` sets have
   the same elements (for testing purposes) *)
let same_vars : varidset -> varidset -> bool =
  SS.equal;;

(* vars_of_list varids -- Generates a set of variable names from a
   list of `varid`s (for testing purposes) *)
let vars_of_list : string list -> varidset =
  SS.of_list ;;
  
(* free_vars exp -- Returns the set of `varid`s corresponding to free
   variables in `exp` *)
   let rec free_vars (exp : expr) : varidset =
    match exp with
    | Var x -> SS.singleton x
    | Num _ | Bool _ | Float _ -> SS.empty
    | Unop (_, e) -> free_vars e
    | Binop (_, e1, e2) -> SS.union (free_vars e1) (free_vars e2)
    | Conditional (cond, out1, out2) -> 
      SS.union (free_vars cond) (SS.union (free_vars out1) (free_vars out2))
    | Fun (var, e) -> SS.remove var (free_vars e)
    | Let (var, def, body) -> 
      SS.union (SS.remove var (free_vars body)) (free_vars def)
    | Letrec (var, def, body) -> 
      SS.remove var (SS.union (free_vars def) (free_vars body))
    | Raise | Unassigned -> SS.empty 
    | App (f, e) -> SS.union (free_vars f) (free_vars e);;



let gensym : string -> string =
let suffix = ref 1 in
fun str -> let symbol = str ^ string_of_int !suffix in
            suffix := !suffix + 1;
            symbol ;;

(* new_varname () -- Returns a freshly minted `varid` with prefix
   "var" and a running counter a la `gensym`. Assumes no other
   variable names use the prefix "var". (Otherwise, they might
   accidentally be the same as a generated variable name.) *)
let new_varname () : varid =
  gensym "var" ;;
  
(*......................................................................
  Substitution 

  Substitution of expressions for free occurrences of variables is the
  cornerstone of the substitution model for functional programming
  semantics.
 *)

(* subst var_name repl exp -- Return the expression `exp` with `repl`
   substituted for free occurrences of `var_name`, avoiding variable
   capture *)
   let rec subst (var_name : varid) (repl : expr) (exp : expr) : expr =
    let subst_piece = subst var_name repl in
    match exp with
    | Var x -> if x = var_name then repl else exp
    | Num _ | Bool _ | Float _ | Raise | Unassigned -> exp
    | Unop (unop, e) -> Unop (unop, subst_piece e)
    | Binop (binop, e1, e2) -> Binop (binop, subst_piece e1, subst_piece e2)
    | Conditional (cond, out1, out2) -> 
      Conditional (subst_piece cond, subst_piece out1, subst_piece out2)
    | Fun (var, e) -> 
      if var = var_name then exp 
      else if SS.mem var (free_vars repl) then 
        let z = new_varname () in 
          Fun (z, subst_piece (subst var (Var z) e))
      else
        Fun (var, subst_piece e)
    | Let (var, def, body) -> 
        if var = var_name then Let (var, subst_piece def, body)
        else if (SS.mem var (free_vars repl)) then
          let z = new_varname () in
            Let (z, subst_piece def, subst_piece (subst var (Var z) body))
        else 
          Let (var, subst_piece def, subst_piece body)
    | Letrec (var, def, body) -> 
        if var = var_name then exp
        else if (SS.mem var (free_vars repl)) then
          let z = new_varname () in
            Letrec (z, subst_piece (subst var (Var z) def), subst_piece (subst var (Var z) body))
        else 
          Letrec (var, subst_piece def, subst_piece body)
    | App (f, e) -> App (subst_piece f, subst_piece e)

  ;;
     
(*......................................................................
  String representations of expressions
 *)
   

 let unop_to_conc_string (u : unop) : string =
  match u with
  | Negate -> "~-"
  | Factorial -> "!" 
  | RandInt -> "RandInt"
  | RandFloat -> "RandFloat"
;;

let binop_to_conc_string (b : binop) : string =
  match b with
  | Plus -> "+" 
  | Minus -> "-"
  | Times -> "*"
  | Divide -> "/"
  | Exponent -> "^"
  | FlPlus -> "+."
  | FlMinus -> "-."
  | FlTimes -> "*."
  | FlDivide -> "/."
  | FlExponent -> "**"
  | Equals -> "="
  | LessThan -> "<"
  | GreaterThan -> ">"
  | Choose -> "C"
;;

let unop_to_abst_string (u : unop) : string =
  match u with
  | Negate -> "Negate"
  | Factorial -> "Factorial"
  | RandInt -> "RandInt"
  | RandFloat -> "RandFloat"

;;

let binop_to_abst_string (b : binop) : string =
  match b with
  | Plus -> "Plus" 
  | Minus -> "Minus"
  | Times -> "Times"
  | Divide -> "Divide"
  | Exponent -> "Exponent"
  | FlPlus -> "FlPlus" 
  | FlMinus -> "FlMinus"
  | FlTimes -> "FlTimes"
  | FlDivide -> "FlDivide"
  | FlExponent -> "FlExponent"
  | Equals -> "Equals"
  | LessThan -> "LessThan"
  | GreaterThan -> "GreaterThan"
  | Choose -> "Choose"
;;

(* exp_to_concrete_string exp -- Returns a string representation of
   the concrete syntax of the expression `exp` *)
let rec exp_to_concrete_string (exp : expr) : string =
  match exp with 
  | Var v -> v
  | Num i -> string_of_int i 
  | Float f -> string_of_float f                      
  | Bool b -> if b then "true" else "false"          
  | Unop (u, e) -> unop_to_conc_string u ^ exp_to_concrete_string e               
  | Binop (b, e1, e2) -> exp_to_concrete_string e1 ^ " " ^ 
    binop_to_conc_string b ^ " " ^ exp_to_concrete_string e2
  | Conditional (pred, res1, res2) -> "if " ^ exp_to_concrete_string pred ^ 
    " then " ^ exp_to_concrete_string res1 ^ " else " ^ exp_to_concrete_string res2
  | Fun (var, e) -> "fun " ^ var ^ " -> " ^ exp_to_concrete_string e      
  | Let (var, def, body) -> "let " ^ var ^ " = " ^ exp_to_concrete_string def ^ 
    " in " ^ exp_to_concrete_string body
  | Letrec (var, def, body) ->  "let rec " ^ var ^ " = " ^ exp_to_concrete_string 
    def ^ " in " ^ exp_to_concrete_string body
  | Raise -> "raise"                       
  | Unassigned -> "unassigned"                
  | App (func, e) -> exp_to_concrete_string func ^ " " ^ exp_to_concrete_string e    
;;
     
(* exp_to_abstract_string exp -- Return a string representation of the
   abstract syntax of the expression `exp` *)


   let rec exp_to_abstract_string (exp : expr) : string =
    match exp with
    | Var x -> "Var(" ^ x ^ ")"                       
    | Num i -> "Num(" ^ string_of_int i ^ ")"
    | Float f -> "Float(" ^ string_of_float f ^ ")"                  
    | Bool b -> if b then "Bool(true)" else "Bool(false)"          
    | Unop (u, e) -> "Unop(" ^ unop_to_abst_string u ^ ", " ^ 
      exp_to_abstract_string e ^ ")"              
    | Binop (b, e1, e2) -> "Binop(" ^ binop_to_abst_string b ^ ", " ^ 
      exp_to_abstract_string e1 ^ ", " ^ exp_to_abstract_string e2 ^ ")"
    | Conditional (cond, out1, out2) -> "Conditional(" ^ 
      exp_to_abstract_string cond ^ ", " ^ exp_to_abstract_string out1 ^ ", " ^ 
      exp_to_abstract_string out2 ^ ")"
    | Fun (var, e) -> "Fun(" ^ var ^ ", " ^ exp_to_abstract_string e ^ ")"  
    | Let (var, def, body) -> "Let(" ^ var ^ ", " ^ exp_to_abstract_string def ^ 
      ", " ^ exp_to_abstract_string body ^ ")"
    | Letrec (var, def, body) ->  "Letrec(" ^ var ^ ", " ^ 
      exp_to_abstract_string def ^ ", " ^ exp_to_abstract_string body ^ ")"
    | Raise -> "raise"                       
    | Unassigned -> "unassigned"      
    | App (func, e) -> "App(" ^ exp_to_abstract_string func ^ ", " ^ 
      exp_to_abstract_string e ^ ")"  
          
  ;;