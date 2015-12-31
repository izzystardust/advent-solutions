type reindeer = { spd: int;
                  dur: int;
                  rst: int; }

let create_reindeer speed duration rest =
   { spd=speed;
     dur=duration;
     rst=rest; }

let periods duration flight_time rest_time =
  duration / (flight_time + rest_time)

let post_distance duration flight_time rest_time speed =
  speed * (min (duration mod (flight_time + rest_time)) flight_time)

let distance duration flight_time rest_time speed =
  (periods duration flight_time rest_time) * speed * flight_time
  + post_distance duration flight_time rest_time speed

let reindeer_distance duration { spd=speed; dur=flight_time; rst=rest_time } =
  distance duration flight_time rest_time speed

let next_points racers at points =
  let distances = BatList.map (reindeer_distance at) racers in
  let m = BatList.max distances in
  BatList.map2 (fun d p -> if d == m then p + 1 else p) distances points

let points duration racers =
  let rec helper duration racers points =
    if duration == 0
    then points
    else helper (duration - 1) racers (next_points racers duration points)
  in
  helper duration racers (BatList.make (BatList.length racers) 0)

let parse_line line =
  let line = Str.split (Str.regexp " +") line in
  (* let name = List.nth line 0 in *)
  let speed = int_of_string (List.nth line 3) in
  let duration = int_of_string (List.nth line 6) in
  let resting = int_of_string (List.nth line 13) in
  create_reindeer speed duration resting

let rec from_stdin state =
  try
    let reindeer = parse_line (read_line ()) in
    from_stdin state @ [reindeer]
  with
  | _ -> state

let main () =
  let race_duration = 2503 in
  let racers = from_stdin [] in
  let distances = List.map (reindeer_distance race_duration) racers in
  let fastest = BatList.max distances in
  let points = points race_duration racers in
  let pointiest = BatList.max points in
  print_string ("Furthest:  " ^ (string_of_int fastest) ^ "\n");
  print_string ("Pointiest: " ^ (string_of_int pointiest) ^ "\n")

let _ = main ()
