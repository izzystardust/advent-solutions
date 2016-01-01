open Batteries

let containers = [50; 44; 11; 49; 42; 46; 18; 32; 26; 40; 21; 7; 18; 43; 10; 47; 36; 24; 22; 40;]

let ways_to_store volume containers =
  let rec helper volume containers used =
    if volume == 0 then [used]
    else if List.length containers == 0 then [[]]
    else let v = List.hd containers in
         helper volume (List.tl containers) used @
           if v <= volume then helper (volume - v) (List.tl containers) (v::used)
           else [[]]
  in List.filter (not % List.is_empty) (helper volume containers [])

let main () =
  let ways = ways_to_store 150 containers in
  let total = List.length ways in
  let short = ways
              |> List.map List.length
              |> List.min in
  let short_ways = List.filter (fun l -> List.length l == short) ways
                   |> List.length in
  print_string ("Total combinations: " ^ (string_of_int total) ^ "\n");
  print_string ("Short combinations: " ^ (string_of_int short_ways) ^ "\n")

let _ = main ()
