open Yojson.Basic.Util
exception UnknownCity of string

type route = {
  from : string;
  destination : string;
  month : string;
  date : string;
  year : string;
  price : string;
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
    month = json |> member "month" |> to_string;
    date = json |> member "date" |> to_string;
    year = json |> member "year" |> to_string;
    price = json |> member "price" |> to_string;
    url = json |> member "url" |> to_string;
  }

let buses_of_json json =
  {
    company = json |> member "company" |> to_string;
    route = json |> member "route" |> to_list |> List.map route_of_json;
  }

let from_json json =
  { buses = json |> member "buses" |> to_list |> List.map buses_of_json }

(* [find_city] is a recursive function that return true if the input [city] is in the [lst]. *)
let rec find_city city lst =
  match lst with
  | [] -> false
  | h :: t -> if h.from = city then true else find_city city t
