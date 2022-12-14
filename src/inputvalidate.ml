open City
open Unix

let data_dir_prefix = "data" ^ Filename.dir_sep
let cities = Yojson.Basic.from_file (data_dir_prefix ^ "cities.json")

let valid_cities =
  let cities_json = City.from_json cities in
  City.output_cities cities_json

(* [ "NYC"; "ITH"; "SYR"; "BOS"; "CHI"; "ATL"; "MTL"; "TOR"; "LA"; "SF"; "EWR";
   "DEN"; ] *)

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

let valid_city c =
  List.mem (c |> String.trim |> String.uppercase_ascii) valid_cities

let currentTime = Unix.localtime (Unix.time ())

let valid_month m =
  try int_of_string m >= 1 && int_of_string m <= 12 with Failure _ -> false

let valid_day m d =
  try
    let m = int_of_string m in
    if m = 2 then int_of_string d <= 29 && int_of_string d > 0
    else
      let max_d = List.assoc m month_day in
      if int_of_string d <= max_d && int_of_string d > 0 then true else false
  with Failure _ -> false

let valid_year y = try int_of_string y >= 0 with Failure _ -> false

let rec find m = function
  | [] -> None
  | (k, v) :: t -> if int_of_string m = k then Some v else find m t

let valid_date m d y =
  try
    if valid_year y && int_of_string y = currentTime.tm_year + 1900 then
      if
        valid_month m
        && int_of_string m >= currentTime.tm_mon + 1
        && valid_day m d
        && int_of_string d >= currentTime.tm_mday
      then true
      else false
    else if valid_year y && int_of_string y > currentTime.tm_year + 1900 then
      if valid_month m && valid_day m d then true else false
    else if int_of_string m <> 2 then
      match find m month_day with
      | None -> false
      | Some x -> x > 0 && x >= int_of_string d
    else if int_of_string y mod 4 = 0 then
      int_of_string d > 0 && int_of_string d <= 29
    else int_of_string d > 0 && int_of_string d <= 28
  with Failure _ -> false
