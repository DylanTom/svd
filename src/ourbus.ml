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

type src_location = {
  lat: float;
  lon: float;
}

type dest_location = {
  lat: float;
  lon: float;
}

type importantinfo = {
  pass_id : int;
  route_id : int;
  src_sm_id: int;
  dest_sm_id: int;
  src_stop_id: int;
  dest_stop_id: int;
  last_stop_id: int;
  available_seat: int;
  default_search: int;
  disclaimer_flag: int;
  src_location: src_location list;
  dest_location : dest_location list;
  src_stop_name: string;
  dest_stop_name: string;
  src_landmark: string;
  dest_landmark: string;
  src_stop_eta: string;
  dest_stop_eta: string;
  src_stop_path: string;
  dest_stop_path: string;
  transport_provider: string;
  pass_amount: float;
  booking_fee: float;
  facility_fee: float;
  travel_date: string;
  expire_time: string;
  route_name: string;
  start_time: string;
  first_stop_name: string;
  first_stop_id: int;
  first_stop_eta: string;
  last_stop_name: string;
  last_stop_eta: string;
  src_zipcode: string;
  dest_zipcode: string;
  first_stop_zipcode: string;
  last_stop_zipcode: string; 
  up_down_type: string;
  trip_status: string;
  trip_amenities: string;
  first_mile: int;
  last_mile: int; 
  trip_id:  int;
  src_day_change: int;
  dest_day_change: int; 
  dest_arrival_date: string;
  src_timezone: string;
  dest_timezone: string; 
  src_travel_date: string;
  partner_trip: string;
  dest_stop_facility_fee_tool_tip: string;
  booking_fee_tool_tip: string;
}

type similarSearch = {
  pass_id : int;
  route_id : int;
  src_sm_id: int;
  dest_sm_id: int;
  src_stop_id: int;
  dest_stop_id: int;
  last_stop_id: int;
  available_seat: int;
  default_search: int;
  disclaimer_flag: int;
  src_location: src_location list;
  dest_location : dest_location list;
  src_stop_name: string;
  dest_stop_name: string;
  src_landmark: string;
  dest_landmark: string;
  src_stop_eta: string;
  dest_stop_eta: string;
  src_stop_path: string;
  dest_stop_path: string;
  transport_provider: string;
  pass_amount: float;
  booking_fee: float;
  facility_fee: float;
  travel_date: string;
  expire_time: string;
  route_name: string;
  start_time: string;
  first_stop_name: string;
  first_stop_id: int;
  first_stop_eta: string;
  last_stop_name: string;
  last_stop_eta: string;
  src_zipcode: string;
  dest_zipcode: string;
  first_stop_zipcode: string;
  last_stop_zipcode: string; 
  up_down_type: string;
  trip_status: string;
  trip_amenities: string;
  first_mile: int;
  last_mile: int; 
  trip_id:  int;
  src_day_change: int;
  dest_day_change: int; 
  dest_arrival_date: string;
  src_timezone: string;
  dest_timezone: string; 
  src_travel_date: string;
  partner_trip: string;
  dest_stop_facility_fee_tool_tip: string;
  booking_fee_tool_tip: string;
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