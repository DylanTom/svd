let valid_cities =
  [ "NYC"; "ITH"; "BOS"; "CHI"; "ATL"; "MTL"; "TOR"; "LA"; "SF"; "EWR"; "DEN" ]

let month_day =
  [
    (1, 31);
    (2, 28);
    (3, 31);
    (4, 30);
    (5, 31);
    (6, 30);
    (7, 31);
    (8, 31);
    (9, 30);
    (10, 31);
    (11, 30);
    (12, 31);
  ]

let city c = List.mem c valid_cities

let rec find m = function
  | [] -> None
  | (k, v) :: t -> if int_of_string m = k then Some v else find m t

let date m d y =
  if int_of_string y < 0 then false
  else if int_of_string m <> 2 then
    match find m month_day with
    | None -> false
    | Some x -> x > 0 && x >= int_of_string d
  else if int_of_string y mod 4 = 0 then
    int_of_string d > 0 && int_of_string d <= 29
  else int_of_string d > 0 && int_of_string d <= 28
