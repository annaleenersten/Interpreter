# Racket Interpreter

This project implements a small Lisp-style interpreter in Racket. It supports parsing and evaluating symbolic expressions, including arithmetic, conditionals, lexical scoping, higher-order functions, and recursion.

The system is tested using RackUnit across multiple test suites that verify parsing, environment lookup, and full interpreter behavior.



## Features

### Arithmetic
- `+`, `-`, `*`
- Nested expressions
- Multi-argument operations

### Data Structures
- `cons`, `car`, `cdr`
- Proper list construction
- `nil`

### Special Forms
- `if`
- `cond`
- `let` (lexical scoping)
- `letrec` (recursive bindings)

### Functions
- Lambda expressions
- Higher-order functions
- Closures with lexical scope

### Recursion
- Factorial
- Map over lists
- Recursive helper functions

---

## 🧪 Running Tests

Run tests using Racket:

```bash
racket test-lookup.rkt
racket test-parse.rkt
racket test-core.rkt
