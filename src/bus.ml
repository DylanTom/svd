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

let rec route_helper = function
  | [] -> []
  | h :: t -> route_of_json h :: route_helper t

let buses_of_json json =
  {
    company = json |> member "company" |> to_string;
    route = json |> member "route" |> to_list |> route_helper;
  }

let rec bus_helper = function
  | [] -> []
  | h :: t -> buses_of_json h :: bus_helper t

let from_json json = { buses = json |> member "buses" |> to_list |> bus_helper }

let rec find_company_helper company lst acc =
  match lst with
  | [] -> raise (UnknownCompany company)
  | h :: t ->
      if h.company = company then h.route @ acc
      else find_company_helper company t acc

let find_company company t =
  try
    let routes = find_company_helper company t.buses [] in
    let bus_list = { company; route = routes } in
    { buses = [ bus_list ] }
  with UnknownCompany c -> failwith "todo"

let rec route_from_helper = function
  | [] -> []
  | h :: t -> h.from :: route_from_helper t

let route_from_list buses c =
  let c_route = (find_company c buses).buses in
  List.fold_left
    (fun acc bus -> List.flatten [ acc; route_from_helper bus.route ])
    [] c_route

let rec route_to_helper = function
  | [] -> []
  | h :: t -> h.from :: route_to_helper t

let rec route_destination_list buses c =
  let c_route = (find_company c buses).buses in
  List.fold_left
    (fun acc bus -> List.flatten [ acc; route_to_helper bus.route ])
    [] c_route

let get_possible_dates route_from route_to = failwith "todo"

let rec check_date date possible =
  match possible with
  | [] -> false
  | h :: t -> if date = h then true else check_date date t

let get_times route date = 
  ("", "")

let get_price route date time = (0., "")
