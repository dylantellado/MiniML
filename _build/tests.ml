open Expr;;
open Evaluation ;;
open CS51Utils ;;
open Absbook;;



let exp_to_concrete_string_tests () = 
  unit_test ((exp_to_concrete_string (Var("x"))) = "x")
    "exp_to_concrete_string var";
  unit_test ((exp_to_concrete_string (Num(1))) = "1")
    "exp_to_concrete_string int";
    unit_test ((exp_to_concrete_string (Float(1.))) = "1.")
    "exp_to_concrete_string int";
  unit_test ((exp_to_concrete_string (Bool(false))) = "false")
    "exp_to_concrete_string bool";
  unit_test ((exp_to_concrete_string (Unop(Negate, Num(10)))) = "~-10")
    "exp_to_concrete_string unop";
  unit_test ((exp_to_concrete_string 
  (Binop(Plus, Num(2), Num(2)))) = "2 + 2")
    "exp_to_concrete_string plus";
  unit_test ((exp_to_concrete_string 
  (Binop(FlMinus, Float(3.), Float(1.)))) = "3. -. 1.")
    "exp_to_concrete_string float minus";
  unit_test ((exp_to_concrete_string 
  (Conditional(Bool(false), Bool(true), Bool(false)))) = "if false then true else false")
    "exp_to_concrete_string conditional";
  unit_test ((exp_to_concrete_string 
  (Fun("y", Binop(Plus, Var("x"), Num(2))))) = "fun y -> x + 2")
    "exp_to_concrete_string fun";
  unit_test ((exp_to_concrete_string 
  (Letrec("f", Num(1), App(Var("f"), Num(2))))) 
    = "let rec f = 1 in f 2")
    "exp_to_concrete_string letrec";
  unit_test ((exp_to_concrete_string (Raise)) = "raise")
    "exp_to_concrete_string raise";
  unit_test ((exp_to_concrete_string (Unassigned)) = "unassigned")
    "exp_to_concrete_string unassigned";
  unit_test ((exp_to_concrete_string (App(Var("f"), Var("x")))) = "f x")
    "exp_to_concrete_string app";;
  
  (* exp_to_abstract_string *)
let exp_to_abstract_string_tests () = 
  unit_test ((exp_to_abstract_string (Var("x"))) = "Var(x)")
    "exp_to_abstract_string var";
  unit_test ((exp_to_abstract_string (Num(5))) = "Num(5)")
    "exp_to_abstract_string num";
  unit_test ((exp_to_abstract_string (Bool(true))) = "Bool(true)")
    "exp_to_abstract_string bool";
  unit_test ((exp_to_abstract_string 
  (Unop(Negate, Num(10)))) = "Unop(Negate, Num(10))")
    "exp_to_abstract_string negate";
  unit_test ((exp_to_abstract_string (Binop(Plus, Num(4), Num(9)))) 
    = "Binop(Plus, Num(4), Num(9))")
    "exp_to_abstract_string plus";
  unit_test ((exp_to_abstract_string (Binop(Times, Num(3), Num(6)))) 
    = "Binop(Times, Num(3), Num(6))")
    "exp_to_abstract_string times";
  unit_test ((exp_to_abstract_string 
  (Conditional(Bool(false), Num(10), Num(4)))) 
    = "Conditional(Bool(false), Num(10), Num(4))")
    "exp_to_abstract_string conditional";
  unit_test ((exp_to_abstract_string 
  (Fun("x", Binop(Times, Var("x"), Num(3))))) 
    = "Fun(x, Binop(Times, Var(x), Num(3)))")
    "exp_to_abstract_string fun";
  unit_test ((exp_to_abstract_string 
  (Letrec("f", Num(5), App(Var("f"), Num(5))))) 
    = "Letrec(f, Num(5), App(Var(f), Num(5)))")
    "exp_to_abstract_string letrec";
  unit_test ((exp_to_abstract_string (App(Var("f"), Num(11)))) 
    = "App(Var(f), Num(11))")
    "exp_to_abstract_string app";;

let empty_set = vars_of_list [] ;;
let set_x = vars_of_list ["x"] ;;
let set_y = vars_of_list ["y"] ;;
let set_xy = vars_of_list ["x"; "y"] ;;

(* Define tests for counting free variables in expressions *)
let free_vars_tests () =
  unit_test (same_vars (free_vars (Num(42))) empty_set) "integer";
  unit_test (same_vars (free_vars (Float(21.))) empty_set) "float";
  unit_test (same_vars (free_vars (Var("x"))) set_x) "single variable";
  unit_test (same_vars (free_vars (Binop (Plus, Var("x"), Var("y")))) set_xy) "binary operation";
  unit_test (same_vars (free_vars (Fun("z", Binop(Plus, Binop(Minus, Binop(Plus, Var("x"), Var("y")), Num(5)), Var("z"))))) set_xy) "Function unbound";
  unit_test (same_vars (free_vars (Fun("y", Binop(Plus, Var("x"), Var("y"))))) set_x) "Function single bound";
  unit_test (same_vars (free_vars (Let("x", Num(7), Binop(Plus, Var("x"), Var("y"))))) set_y) "Let single bound";
  unit_test (same_vars (free_vars (Let("y", Binop(Plus, Var("x"), Num(10)), Var("y")))) set_x) "Let double bound";
  unit_test (same_vars (free_vars (Let("x", Num(5), Let("y", Num(2), Binop(Plus, Var("x"), Var("y")))))) empty_set) "double Let double bound";;

let subst_tests () =
  unit_test (subst "x" (Num(5)) (Num(3)) = Num(3)) "int" ;
  unit_test (subst "x" (Float(5.)) (Float(3.)) = Float(3.)) "float" ;
  unit_test (subst "x" (Num(5)) (Var("x")) = Num(5)) "variable sub to int" ;
  unit_test (subst "x" (Var("y")) (Var("x")) = Var("y")) "variable sub to var" ;
  unit_test (subst "x" (Var "y") (Var("z")) = Var("z")) "variable nosub" ;
  unit_test ((subst ("x") (Num(2)) (Binop(Plus, Var("x"), Num(7)))) = Binop(Plus, Num(2), Num(7))) "subst plus int";
  unit_test ((subst ("x") (Float(2.)) (Binop(Plus, Var("x"), Float(7.)))) = Binop(Plus, Float(2.), Float(7.))) "subst plus float";
  unit_test (subst "x" (Var "y") (Binop(Times, Var("x"), Var("y"))) = Binop(Times, Var("y"), Var("y"))) "subst times var" ;
  unit_test (subst "x" (Var "y") (Fun("x", Binop(Plus, Var("x"), Var("x")))) = (Fun ("x", Binop(Plus, Var("x"), Var("x"))))) "subst fun" ;
  unit_test (subst "y" (Var "z") (Fun("x", Binop(Plus, Var("x"), Var("y")))) = (Fun ("x", Binop(Plus, Var("x"), Var("z"))))) "subst fun 2" ;
  unit_test (subst "x" (Num(4)) (Let("x", Binop(Plus, Var ("x"), Num(3)), Var("x"))) = Let("x", Binop(Plus, Num(4), Num(3)), Var("x"))) "subst let" ;
  unit_test (subst "x" (Num(4)) (Let("y", Binop(Plus, Var ("x"), Num(3)), Var("x"))) = Let("y", Binop(Plus, Num(4), Num(3)), Num(4))) "subst let 2" ;;

(* Defining environments for eval_d and eval_l tests *)
let emp_env = Env.empty () ;;
let env1 = Env.extend emp_env "x" (ref (Env.Val (Num(2))));;

(* Tests shared between different evaluators*)
let eval_tests evaluator = 
  unit_test (evaluator (Num(3))(emp_env) = Env.Val(Num(3))) "eval_test int";
  unit_test (evaluator (Float(2.))(emp_env) = Env.Val(Float(2.))) "eval_test float";
  unit_test (evaluator (Bool(false))(emp_env) = Env.Val(Bool(false))) "eval_test bool";
  unit_test (evaluator (Unop(Negate,Bool(false)))(emp_env) = Env.Val(Bool(true))) "eval_test negate bool";
  unit_test (evaluator (Binop(Plus, Num(1), Num(2)))(emp_env) = Env.Val(Num(3))) "eval_test plus";
  unit_test (evaluator (Binop(FlTimes, Float(4.), Float(3.)))(emp_env) = Env.Val(Float(12.))) "eval_test float times";
  unit_test (evaluator (Binop(FlExponent, Float(2.), Float(3.)))(emp_env) = Env.Val(Float(8.))) "eval_test float exponent";
  unit_test (evaluator (App(Fun( "x", Binop(Plus, Var("x"), Var("x"))), Num(2)))(emp_env) = Env.Val(Num(4))) "eval_test app";
  unit_test (evaluator (Let("x", Binop(Plus, Num(4), Num(3)), Var("x")))(emp_env) = Env.Val(Num(7))) "eval_test let" ;
  unit_test (evaluator (Let("y", Binop(Plus, Num(4), Num(3)), Num(4)))(emp_env) = Env.Val(Num(4))) "eval_test let 2" ;;

let extensions_tests () = 
  unit_test (eval_d (Binop(Exponent, Num(2), Num(4)))(emp_env) = Env.Val(Num(16))) "eval_extension Exponent";
  unit_test (eval_d (Binop(FlExponent, Float(2.), Float(4.)))(emp_env) = Env.Val(Float(16.))) "eval_extension FlExponent";
  unit_test (eval_d (Unop(Factorial, Num(5)))(emp_env) = Env.Val(Num(120))) "eval_extension factorial";
  unit_test (eval_d (Binop(Choose, Num(10), Num(2)))(emp_env) = Env.Val(Num(45))) "eval_extension Choose";;

let eval_d_tests () = 
  unit_test (eval_d (Num(3))(env1) = Env.Val(Num(3))) "eval_d int";
  unit_test (eval_d (Var("x"))(env1) = Env.Val(Num(2))) "eval_d var";
  unit_test (eval_d (Binop(Plus, Var("x"), Num(2)))(env1) = Env.Val(Num(4))) "eval_d binop";;
  unit_test (eval_d (Letrec("f", Fun("x", Conditional(Binop(Equals, Var("x"), Num(0)), Num(1), Binop(Times, Var("x"), App(Var("f"), Binop(Minus, Var("x"), Num(1)))))), App(Var("f"), Num(5)))) emp_env = Env.Val (Num 120)) "eval_d letrec (factorial)" ;
  unit_test (eval_d (Let("x", Num(1), Let("f", Fun("y", Binop(Plus, Var("x"), Var("y"))), Let("x", Num(2), App(Var("f"), Num(3))))))(emp_env) = Env.Val(Num(5))) "eval_d triple let";;


let eval_l_tests () = 
  unit_test (eval_l (Num(3))(env1) = Env.Val(Num(3))) "eval_l int";
  unit_test (eval_l (Var("x"))(env1) = Env.Val(Num(2))) "eval_l var";
  unit_test (eval_l (Binop(Plus, Var("x"), Num(2)))(env1) = Env.Val(Num(4))) "eval_l binop";;
  unit_test (eval_l (Letrec("f", Fun("x", Conditional(Binop(Equals, Var("x"), Num(0)), Num(1), Binop(Times, Var("x"), App(Var("f"), Binop(Minus, Var("x"), Num(1)))))), App(Var("f"), Num(5)))) emp_env = Env.Val (Num 120)) "eval_l letrec (factorial)" ;
  unit_test (eval_l (Let("x", Num(1), Let("f", Fun("y", Binop(Plus, Var("x"), Var("y"))), Let("x", Num(2), App(Var("f"), Num(3))))))(emp_env) = Env.Val(Num(4))) "eval_l triple let";;
;;

let tests () =
  exp_to_concrete_string_tests () ;
  exp_to_abstract_string_tests () ;
  free_vars_tests () ;
  subst_tests () ;
  eval_tests eval_s ;
  eval_tests eval_d ;
  eval_tests eval_l;
  extensions_tests () ;
  eval_d_tests () ;
  eval_l_tests () ;;



let _ = tests () ;;



