open Yojson.Basic.Util

type city = {
  city_name : string;
  megabus : int;
  ourbus : string;
}

type company =
  | Int of int
  | String of string

type t = { cities : city list }

let city_of_json j =
  {
    city_name = j |> member "city" |> to_string;
    megabus = j |> member "Megabus" |> to_int;
    ourbus = j |> member "Ourbus" |> to_string;
  }

let rec map_cities = function
  | [] -> []
  | h :: t -> city_of_json h :: map_cities t

let from_json j = { cities = j |> member "cities" |> to_list |> map_cities }

(******************************************************************************)

let output_cities t =
  let rec output_cities_helper acc = function
    | [] -> acc
    | h :: t -> h.city_name :: output_cities_helper acc t
  in
  output_cities_helper [] t.cities

let rec find_city c company = function
  | [] -> raise Not_found
  | h :: t ->
      if h.city_name = c then
        if company = "megabus" then Int h.megabus else String h.ourbus
      else find_city c company t

let megabus_of_city c t =
  try
    match find_city c "megabus" t.cities with
    | Int 0 -> raise Not_found
    | Int i -> i
    | _ -> failwith "impossible"
  with Not_found -> 0 

let ourbus_of_city c t =
  try
    match find_city c "ourbus" t.cities with
    | String "" -> raise Not_found
    | String s -> s
    | _ -> failwith "Impossible"
  with
  | Not_found -> ""
