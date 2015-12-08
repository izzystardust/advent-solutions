open Map
open Str

type value =
    Number of int | Wire of string

type wire =
    Value    of value
    | NOT    of value
    | AND    of (value * value)
    | OR     of (value * value)
    | LSHIFT of (value * int)
    | RSHIFT of (value * int)

let parse_value v =
    try Number (int_of_string v) with 
    | _ -> Wire v

let binop line =
    (parse_value (List.nth line 0), parse_value (List.nth line 2))

let shiftop line =
    (parse_value (List.nth line 0), int_of_string (List.nth line 2))

let parse_line line =
    let line = Str.split (Str.regexp " +") line in
    (List.nth line (List.length line - 1), 
    match List.length line with
    3 -> Value (parse_value (List.nth line 0)) (* value -> wire *)
    | 4 -> NOT (parse_value (List.nth line 1))
    | 5 -> (match List.nth line 1 with
            "AND" -> AND (binop line)
            | "OR" -> OR (binop line)
            | "LSHIFT" -> LSHIFT (shiftop line)
            | "RSHIFT" -> RSHIFT (shiftop line)
            | a -> raise (Failure ("unexpected: " ^ a)))
    | _ -> raise (Failure "wat"))

let rec from_stdin state =
    try
        let line = read_line () in
        let (name, value) = parse_line line in
        Hashtbl.add state name value;
        from_stdin state
    with
    | _ -> state

let to16 num = num land 0xFFFF

let rec evaluate w wires =
    let value = (match Hashtbl.find wires w with
    Value v -> evaluate_val v wires
    | NOT v -> to16 (lnot (to16 (evaluate_val v wires)))
    | AND (x, y) -> to16 ((evaluate_val x wires) land (evaluate_val y wires))
    | OR (x, y) -> to16 ((evaluate_val x wires) lor (evaluate_val y wires))
    | LSHIFT (v, b) -> to16 ((evaluate_val v wires) lsl b)
    | RSHIFT (v, b) -> to16 ((evaluate_val v wires) lsr b)) in
    Hashtbl.replace wires w (Value (Number value));
    value
and evaluate_val v wires =
    match v with
    Number n -> to16 n
    | Wire s -> to16 (evaluate s wires)

let main () =
    let circuit = from_stdin (Hashtbl.create 50) in
    let second_circuit = Hashtbl.copy circuit in
    let answer = evaluate "a" circuit in
    print_string ("Wire a: " ^ string_of_int answer ^ "\n");
    Hashtbl.replace second_circuit "b" (Value (Number answer));
    print_string ("New a:  " ^ (string_of_int (evaluate "a" second_circuit)) ^ "\n")


let _ = main ()

(*for part two, I just edited the input file to change the original value of b*)
