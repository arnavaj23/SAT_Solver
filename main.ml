(*                                                      ||  ॐ गं गणपतये नमः  ||  *)

open Printf

(* ---------------------- Type Definitions ------------------------ *)
type literal = int
and clause = literal list
and cnf = clause list
and assignment = (int * bool) list

let call_counter = ref 0

(* -------------------- DIMACS Parser from stdin -------------------- *)
let read_cnf_from_stdin () : cnf =
  let rec read_clauses acc =
    try
      let line = read_line () in
      let trimmed = String.trim line in
      if trimmed = "" || trimmed.[0] = 'c' then read_clauses acc 
      else if trimmed.[0] = 'p' then read_clauses acc 
      else
        let nums = trimmed
                   |> String.split_on_char ' '
                   |> List.filter (fun x -> x <> "")
                   |> List.map int_of_string in
        let clause = List.filter ((<>) 0) nums in
        read_clauses (clause :: acc)
    with End_of_file -> List.rev acc
  in
  read_clauses []

(* ------------------------ CNF Utilities ------------------------ *)
let has_empty_clause (f : cnf) : bool =
  List.exists (fun clause -> clause = []) f

let simplify (f : cnf) (lit : literal) : cnf =
  let neg_lit = -lit in
  List.filter_map (fun clause ->
    if List.mem lit clause then None
    else Some (List.filter ((<>) neg_lit) clause)) f

let pick_literal (f : cnf) : literal =
  match f with
  | [] -> failwith "No literal to pick"
  | clause::_ -> List.hd clause

(* ------------------------ DPLL Solver ------------------------ *)
let rec dpll (f : cnf) (assign : assignment) : assignment option =
  incr call_counter;
  if f = [] then Some assign
  else if has_empty_clause f then None
  else
    let lit = pick_literal f in
    let f_pos = simplify f lit in
    let f_neg = simplify f (-lit) in
    match dpll f_pos ((lit, true)::assign) with
    | Some result -> Some result
    | None -> dpll f_neg ((lit, false)::assign)

(* -------------------- Assignment Printer -------------------- *)
let print_assignment (assign : assignment) : unit =
  let normalized =
    List.map (fun (lit, value) ->
      let var = abs lit in
      let actual_value = if lit > 0 then value else not value in
      (var, actual_value)) assign
  in
  let sorted = List.sort_uniq (fun (a, _) (b, _) -> compare a b) normalized in
  List.iter (fun (var, value) ->
    Printf.printf "Variable %d = %b\n" var value) sorted

(* --------------------------- Main --------------------------- *)
let () =
  let formula = read_cnf_from_stdin () in
  let result = dpll formula [] in
  Printf.printf "Recursive calls made: %d\n" !call_counter;
  match result with
  | Some assignment ->
      print_endline "SAT";
      print_assignment assignment
  | None ->
      print_endline "UNSAT"
