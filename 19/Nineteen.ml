open Batteries

let mol = "HOH"

let parse_line line =
  let line = String.split line " => " in
  let left = fst line in
  let right = snd line in
  (String.get left 0, right)

let mappings_from_stdin () =
  let rec helper lines =
    try
      let line = parse_line (read_line ()) in
      helper (line::lines)
    with | _ -> lines in
  helper []


let collapse mappings =
  let add_mapping ms (f, t) =
    if Map.mem f ms
    then
      let old_ms = Map.find f ms in
      Map.add f (t::old_ms) ms
    else Map.singleton f [t] in
  List.fold_left add_mapping Map.empty mappings

let from_stdin () =
  let mappings = collapse ( mappings_from_stdin () ) in
  let starter = read_line () in
  (starter, mappings)

let apply k vs mol =
  let ks = String.make 1 k in
  let rec helper idx =
    try
      let next_occurance = String.index_from mol idx k in
      let mol_start = String.left mol idx in
      let mol_post = String.lchop ~n:idx mol in
      let with_change = List.map (fun s -> mol_start ^ (snd (String.replace mol_post ks s))) vs in
      with_change @ helper (next_occurance + 1)
    with
    | _ -> []
  in helper 0

let possible_in_step mappings mol =
  Map.foldi (fun k v a -> apply k v mol @ a) mappings []
  |> List.sort_uniq Pervasives.compare

let main () =
  let (init, mappings) = from_stdin () in
  let possibilities = possible_in_step mappings init in
  let count = List.length possibilities in
  print_string ("Distinct molecules: " ^ (string_of_int count) ^ "\n")

let _ = main ()
