# OCaml SAT Solver (DPLL Algorithm)

> A minimal SAT solver built in OCaml using the recursive DPLL algorithm. Takes CNF formulas in DIMACS format as standard input.

---

## Overview

This is a fully functional SAT solver written in **pure OCaml**, based on the classic **DPLL (Davis-Putnam-Logemann-Loveland)** algorithm. It determines whether a given Boolean formula in **CNF (Conjunctive Normal Form)** is satisfiable, and prints the satisfying assignment if one exists.

---

## Features

* Reads input in **DIMACS CNF** format via standard input
* Fully **recursive implementation** of DPLL
* Tracks number of recursive calls for performance insight
* Returns satisfying assignment if one exists
* Compact and elegant: \~100 lines of clean OCaml

---

## Input Format (DIMACS)

Example CNF input:

```
p cnf 3 3
-1 -1 -1 0
-2 -2 -2 0
-3 -3 -3 0
```

* Each clause ends with a `0`
* Literals are integers: `1` = A, `-2` = ¬B
* Ignore comment lines starting with `c`

---

##  How to Run

###  Compile

```bash
ocamlc -o solver main.ml
```

###  Execute

```bash
./solver < test.cnf
```

Or paste input into terminal and end with Ctrl+D (Linux/macOS) or Ctrl+Z (Windows).

---

##  Sample Output

```
Recursive calls made: 4
SAT
Variable 1 = false
Variable 2 = false
Variable 3 = false
```

---

## 👤 Author

Arnav | IIT Kanpur

---

## ⭐️ Inspired By

* Jane Street’s use of OCaml
* Logical thinking and functional programming paradigms
