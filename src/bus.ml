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

(** [find_company] is a recursive function that takes the inputs [company lst].
    It will raise an UnknownCompany exception if the company is not in the list.
    If it does exist in the list, it return the company in json format.*)
let rec find_company company lst =
  match lst with
  | [] -> raise (UnknownCompany company)
  | h :: t -> if h.company = company then h else find_company company t

(** [route_from_list] is a recursive function that takes the input [lst] of type
    buses list and outputs a list of the route from type with the type string
    list*)
let rec route_from_list lst =
  match lst with
  | [] -> []
  | h :: t -> h.from :: route_from_list t

(** [route_destination_list] is a recursive function that takes the input [lst]
    of type buses list and outputs a list of the route destination type with the
    type string list*)
let rec route_destination_list lst =
  match lst with
  | [] -> []
  | h :: t -> h.destination :: route_destination_list t

(** [get_possible_dates] is a recursive function that takes in the inputs
    [route_from_list route_destination_list]. It checks if the specific
    route_from and route_destination exists. if it does, return the list of
    possible dates. if false, raise UnknownRoute exception.*)

(** [check_date] takes in the inputs [date possible_dates]. It checks if the
    specific date is in the list of possible dates. if false, raise UnknownRoute
    exception*)

(** [get_times] takes in the inputs [route date]. It returns the timeleave and
    time arrive of the valide bus route.*)

(** [get_price] takes in the inputs [route date time]. It returns the price and
    the url to the bus ticket.*)
