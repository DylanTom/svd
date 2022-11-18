open Yojson.Basic.Util

exception UnknownCompany of string
exception UnknownCity of string

type route = {
  from : string;
  destination : string;
  month : int;
  date : int;
  year : int;
  price : int;
  timeleave : string;
  timearrive : string;
  url : string;
}

type buses = {
  company : string;
  route : route list;
}

type t = { buses : buses list }

let route_of_json json =
  {
    from = json |> member "from" |> to_string;
    destination = json |> member "destination" |> to_string;
    month = json |> member "month" |> to_int;
    date = json |> member "date" |> to_int;
    year = json |> member "year" |> to_int;
    price = json |> member "price" |> to_int;
    timeleave = json |> member "timeleave" |> to_string;
    timearrive = json |> member "timearrive" |> to_string;
    url = json |> member "url" |> to_string;
  }

let buses_of_json json =
  {
    company = json |> member "company" |> to_string;
    route = json |> member "route" |> to_list |> List.map route_of_json;
  }

let from_json json =
  { buses = json |> member "buses" |> to_list |> List.map buses_of_json }

let rec find_company company lst =
  match lst with
  | [] -> raise (UnknownCompany company)
  | h :: t -> if h.company = company then h else find_company company t

let rec route_from_list lst =
  match lst with
  | [] -> []
  | h :: t -> h.from :: route_from_list t

(* let rec route_destination_list lst =
  match lst with
  | [] -> []
  | h :: t -> h.destination :: route_destination_list t *)


