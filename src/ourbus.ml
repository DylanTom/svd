open Mechaml
module M = Agent.Monad
open M.Infix
open Sys

type query = {
  departureDate : string;
  destinationId : string;
  originId : string;
  totalPassengers : string;
}

let get_departure_date q = q.departureDate
let get_dest q = q.destinationId
let get_orig q = q.originId
let get_passengers q = q.totalPassengers

let make_query dep_date dest ori =
  {
    departureDate = dep_date;
    destinationId = dest;
    originId = ori;
    totalPassengers = "1";
  }

let rec concat = function
  | [] -> ""
  | h :: t -> h ^ concat t

let get_uri q =
  let to_build =
    [
      "origin=" ^ q.originId;
      "&destination=" ^ q.destinationId;
      "&departure_date=" ^ q.departureDate;
      "&adult=" ^ q.totalPassengers;
    ]
  in
  let query_params = concat to_build in
  "https://www.ourbus.com/booknow?" ^ query_params

let require msg = function
  | Some a -> a
  | None -> failwith msg

let url =
  {|"https://www.ourbus.com/booknow?origin=New%20York,%20NY&destination=Ithaca,%20NY&departure_date=12/08/2022&adult=1"|}

let run_parser = Sys.command ("python3 script/parse_web.py " ^ url)
