open Batteries

type state = On | Off

let state_of_char c = match c with
  | '.' -> Off
  | '#' -> On
  | _ -> failwith "Not a good char."

let parse_line line =
  String.enum line
  |> Enum.map state_of_char
  |> List.of_enum

let set_of_row idx contents =
  List.fold_lefti (fun set col v -> match v with
                                    | On -> Set.add (col, idx) set
                                    | Off -> set)
                  Set.empty contents

let from_stdin () =
  let rec helper s =
    try
      let line = parse_line (read_line ()) in
      helper (line::s)
    with | _ -> s in
  let grid = List.rev (helper []) in
  List.mapi set_of_row grid
  |> List.reduce Set.union

let neighbors_on x y state =
  let neighbors = [(x-1,y-1); (x-1, y); (x-1,y+1);
                   (x,y-1); (x,y+1);
                   (x+1,y-1); (x+1,y); (x+1,y+1)] in
  List.map (fun n -> Set.mem n state) neighbors
  |> List.filter identity
  |> List.length

let next_state state x y =
  let t = neighbors_on x y state in
  if Set.mem (x, y) state
  then match t with
       | 2 | 3 -> On
       | _ -> Off
  else match t with
       | 3 -> On
       | _ -> Off

let step size state =
  let xs = List.range 0 `To size in
  let ys = List.range 0 `To size in
  let positions = List.map (fun x -> List.map (fun y -> (x, y)) xs) ys |> List.flatten (*ew *) in
  List.map (fun (x, y) -> (x, y, next_state state x y)) positions
  |> List.fold_left (fun s (x, y, v) -> match v with
                                        | On -> Set.add (x, y) s
                                        | Off -> s) Set.empty

let step_stuck size state =
  let corners = Set.of_list [(0,0); (0, size); (size, 0); (size, size)] in
  Set.union corners (step size (Set.union corners state))

let rec after n f i0 = if n <= 0 then i0 else after (n-1) f (f i0)

let main () =
  let s0 = from_stdin () in
  let at_end = after 100 (step 99) s0 |> Set.cardinal in
  let oopsie = after 100 (step_stuck 99) s0 |> Set.cardinal in
  print_string ("Lights on: " ^ (string_of_int at_end) ^ "\n");
  print_string ("Lights on: " ^ (string_of_int oopsie) ^ "\n")

let _ = main ()
