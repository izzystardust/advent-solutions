    open Batteries

    let floor0 x = if x < 0 then 0 else x

    (*Didn't want to deal with input.*)
    let ingrs = [[5; -1; 0; -1]; [-1; 3; -1; 0]; [0; 0; 4; 0]; [0; 0; 0; 2]]
    let cals = [5; 1; 6; 8];;

    let score_ingr ingr weights =
      List.map2 (fun a b -> a * b) ingr weights
      |> List.sum

    let score ingrs weights =
      List.map (fun i -> score_ingr i weights) ingrs
      |> List.map floor0
      |> List.reduce (fun x y -> x * y)

    let possibilities max =
      let all = ref [] in
      for i = 0 to max do
        for j = 0 to max do
          for k = 0 to max do
            for l = 0 to max do
              if (i + j + k + l == max) then all:=[i;j;k;l]::!all
            done
          done
        done
      done;
      !all

    let best ingr_list ps =
      List.map (score ingr_list) ps |> List.max

    let valid_cals cals target weights =
      List.sum (List.map2 (fun c w -> c * w) cals weights) == target

    let main () =
      let ps = possibilities 100 in
      let b = best ingrs ps in
      let c = best ingrs (List.filter (valid_cals cals 500) ps) in
      print_string ("Best: " ^ (string_of_int b) ^ "\n");
      print_string ("Next: " ^ (string_of_int c) ^ "\n")

    let _ = main ()
