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
  {|"https://www.ourbus.com/booknow?origin=New%20York,%20NY&destination=Ithaca,%20NY&departure_date=12/13/2022&adult=1"|}

let run_parser = Sys.command ("python3 script/parse_web.py " ^ url)

type voucher = {
  id : int;
  coupon_id : int;
  voucher_name : string;
}

type importantinfo = {
  pass_id : int;
  route_id : int;
}

type similarSearch = {
  pass_id : int;
  route_id : int;
}

type data_search_data = {
  date : string;
  lowest_price : float;
  route_available : bool;
  seats_full : bool;
}

type searchedRouteList = {
  voucher : voucher list;
  importantinfo : importantinfo list;
  similarSearch : similarSearch list;
  date_search_data : data_search_data list;
  statusCode : int;
}

type t = {
  searchedRouteList : searchedRouteList list;
  typeType : string;
  numberOfAdults : string;
  date_month : string;
  dateMonthType : string;
}