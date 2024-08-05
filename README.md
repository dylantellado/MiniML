# MiniML

This project involves the development of MiniML, a simplified subset of the OCaml programming language. The interpreter supports core language constructs such as arithmetic operations, conditionals, and function definitions. Additionally, the language has been enhanced with:

- Support for floats, enabling more versatile mathematical computations.
- Additional operators, including division, exponents, random number generation, factorial computation, and binomial coefficient calculation.

## Semantic Models

The project features advanced semantic models, including both dynamic and lexical scoping. The evaluators use closures to accurately capture and manage lexical environments, supporting the correct execution of recursive functions and complex expressions.

## Running and Using the MiniML Interpreter

### Compile the Interpreter:
1. Ensure that all required dependencies and OCaml packages are installed.
2. Run the compilation command to build the interpreter:
    ```sh
    ocamlbuild -use-ocamlfind miniml.byte
    ```

### Start the Interpreter:
- Execute the following command to launch the MiniML interpreter:
    ```sh
    ./miniml.byte
    ```

### Input and Execute Expressions:

- Begin typing MiniML (OCaml-like) expressions in the terminal.
- End each expression with `;;` to execute it.

**Examples:**

- **Simple Arithmetic:**
    ```ocaml
    3 + 4;;
    10 - 2;;
    5 * 6;;
    9 / 3;;
    ```

- **Float Arithmetic:**
    ```ocaml
    3.5 +. 4.2;;
    10.0 -. 2.5;;
    5.3 *. 6.2;;
    9.0 /. 3.0;;
    ```

- **Let Statements:**
    ```ocaml
    let x = 3 + 4 in x * x;;
    let y = 10 in y / 2;;
    ```

- **Conditional Statements:**
    ```ocaml
    let x = 5 in if x > 5 then 2 else 3;;
    ```

- **Function Definitions and Execution:**
    ```ocaml
    let add a b = a + b in add 3 4;;
    
    let rec factorial n = 
        if n = 0 then 1 
        else n * factorial (n - 1) in factorial 5;;
    ```

- **Random Number Generation:**
    ```ocaml
    randint 10;;
    randfloat 5.0;;
    ```
- **Exponents:**
    ```ocaml
    2 ^ 5;;
    3 ^ 3;;
    ```

- **Factorial:**
    ```ocaml
    5!;;
    7!;;
    ```

- **Binomial Coefficient Calculation:**
    ```ocaml
    10 choose 2;;
    5 choose 3;;
    ```
    
### Exit the Interpreter:
- Use `Ctrl + D` to exit the interpreter.
