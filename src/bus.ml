open Yojson
open Yojson.Basic
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

let rec find_company_helper company lst acc =
  match lst with
  | [] -> raise (UnknownCompany company)
  | h :: t -> if h.company = company then h.route @ acc else find_company_helper company t acc

let find_company company t = 
  let routes = find_company_helper company t.buses [] in 
  let bus_list = {company = company; route = routes} in
  {buses = [bus_list]}

let rec route_from_list lst = failwith "todo"
  (* match lst with
  | [] -> []
  | h :: t -> h.from :: route_from_list t *)

let rec route_destination_list lst = failwith "todo"
  (* match lst with
  | [] -> []
  | h :: t -> h.destination :: route_destination_list t *)

let get_possible_dates route_from route_to = failwith "todo"
let check_date _ _ = failwith "todo"
let get_times _ _ = failwith "todo"
let get_price _ _ = failwith "todo"
