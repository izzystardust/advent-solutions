open Batteries

let parse_line line =
  let line = Str.split (Str.regexp "[ ,:]+") line in
  let keys = List.map (List.nth line) [2; 4; 6] in
  let vals = List.map (int_of_string % List.nth line) [3; 5; 7] in
  List.fold_left2 (fun m k v -> Map.add k v m) Map.empty keys vals


let to_line sue =
  "Sue has" ^ Map.foldi (fun k v a -> a ^ ", " ^ k ^ ": " ^ (string_of_int v)) sue ""

let from_stdin () =
  let rec helper s =
    try
      let sue = parse_line (read_line ()) in
      helper (s @ [sue])
    with
    | _ -> s
  in helper []

(* Meh. *)
let knowns =
  let cats = ["children";"cats";"samoyeds";"pomeranians";"akitas";
              "vizslas";"goldfish";"trees";"cars";"perfumes"] in
  let vals = [3;7;2;3;0;0;5;3;2;1;] in
  List.map2 (fun k v -> (k, v)) cats vals

let possible_category sue (c, v) =
  if Map.mem c sue
  then v == Map.find c sue
  else true

let possible_category_2 sue (c, v) =
  try
    let count = Map.find c sue in
    match c with
    | "cats" | "trees" -> v < count
    | "pomeranians" | "goldfish" -> v > count
    | _ -> v == count
  with _ -> true

let is_possible_sue p knowns sue =
  knowns
  |> List.map (p sue)
  |> List.for_all identity

let find_with p knowns sues =
  1 + fst (List.findi (fun _ s -> is_possible_sue p knowns s) sues)

let main () =
  let sues = from_stdin () in
  let p1 = find_with possible_category knowns sues in
  let p2 = find_with possible_category_2 knowns sues in
  print_string ("It's from Sue " ^ (string_of_int p1) ^ "\n");
  print_string ("Or possibly " ^ (string_of_int p2) ^ "\n")

let _ = main()
