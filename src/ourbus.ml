open Mechaml
module M = Agent.Monad
open M.Infix
open Sys
open Yojson
open Yojson.Basic
open Yojson.Basic.Util

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
  {|"https://www.ourbus.com/booknow?|} ^ query_params ^ {|"|}

let require msg = function
  | Some a -> a
  | None -> failwith msg

let url =
  {|"https://www.ourbus.com/booknow?origin=New%20York,%20NY&destination=Ithaca,%20NY&departure_date=12/13/2022&adult=1"|}

let run_parser q =
  let url = get_uri q in
  Sys.command ("python3 script/parse_web.py " ^ url)

type voucher = {
  id : int;
  coupon_id : int;
  voucher_name : string;
}

type src_location = {
  lat : float;
  lon : float;
}

type dest_location = {
  lat : float;
  lon : float;
}

type importantinfo = {
  pass_id : int; (*important*)
  route_id : int; (*important*)
  src_sm_id : int; (*important*)
  dest_sm_id : int; (*important*)
  src_stop_id : int; (*important*)
  dest_stop_id : int; (*important*)
  available_seat : int; (*important*)
  src_stop_name : string; (*important*)
  dest_stop_name : string; (*important*)
  src_landmark : string; (*important*)
  dest_landmark : string; (*important*)
  src_stop_eta : string; (*important*)
  dest_stop_eta : string; (*important*)
  pass_amount : float; (*important*)
  booking_fee : float; (*important*)
  facility_fee : float; (*important*)
  travel_date : string; (*important*)
  route_name : string; (*important*)
}

type similarSearch = {
  (* pass_id : int; route_id : int; src_sm_id : int; dest_sm_id : int;
     src_stop_id : int; dest_stop_id : int; last_stop_id : int; available_seat :
     int; default_search : int; disclaimer_flag : int; src_location :
     src_location list; dest_location : dest_location list; src_stop_name :
     string; last_stop_eta : string; src_zipcode : string; dest_zipcode :
     string; booking_fee : float; facility_fee : float; travel_date : string;*)
  expire_time : string;
  up_down_type : string;
  trip_status : string;
  trip_amenities : string;
  first_mile : int;
  last_mile : int;
  trip_id : int;
  src_day_change : int;
  dest_day_change : int;
  dest_arrival_date : string;
  src_timezone : string;
  dest_timezone : string;
  src_travel_date : string;
  partner_trip : string;
  dest_stop_facility_fee_tool_tip : string;
  booking_fee_tool_tip : string;
}

type data_search_data = {
  date : string;
  lowest_price : float;
  route_available : bool;
  seats_full : bool;
}

type searchedRouteList = {
  (* voucher : voucher list; *)
  importantinfo : importantinfo list;
      (* similarSearch : similarSearch list; date_search_data : data_search_data
         list; statusCode : int; *)
}

type t = {
  searchedRouteList : searchedRouteList;
      (* typeType : string; numberOfAdults : string; date_month : string;
         dateMonthType : string; *)
}

let importantinfo_of_json json =
  {
    pass_id = json |> member "pass_id" |> to_int;
    route_id = json |> member "route_id" |> to_int;
    src_sm_id = json |> member "src_sm_id" |> to_int;
    dest_sm_id = json |> member "dest_sm_id" |> to_int;
    src_stop_id = json |> member "src_stop_id" |> to_int;
    dest_stop_id = json |> member "dest_stop_id" |> to_int;
    available_seat = json |> member "available_seat" |> to_int;
    src_stop_name = json |> member "src_stop_name" |> to_string;
    dest_stop_name = json |> member "dest_stop_name" |> to_string;
    src_landmark = json |> member "src_landmark" |> to_string;
    dest_landmark = json |> member "dest_landmark" |> to_string;
    src_stop_eta = json |> member "src_stop_eta" |> to_string;
    dest_stop_eta = json |> member "dest_stop_eta" |> to_string;
    pass_amount = json |> member "pass_amount" |> to_float;
    booking_fee = json |> member "booking_fee" |> to_float;
    facility_fee = json |> member "facility_fee" |> to_float;
    travel_date = json |> member "travel_date" |> to_string;
    route_name = json |> member "route_name" |> to_string;
  }

let rec voucher_helper lst =
  match lst with
  | [] -> []
  | h :: t -> failwith "unimplemented"

let rec importantinfo_helper lst =
  match lst with
  | [] -> []
  | h :: t -> importantinfo_of_json h :: importantinfo_helper t

let rec similarSearch_helper lst =
  match lst with
  | [] -> []
  | h :: t -> failwith "unimplemented"

let rec date_search_data_helper lst =
  match lst with
  | [] -> []
  | h :: t -> failwith "unimplemented"

let searchedRouteList_of_json json =
  {
    (* voucher = json |> member "voucher" |> to_list |> voucher_helper; *)
    importantinfo =
      json |> member "list" |> to_list |> importantinfo_helper
      (* similarSearch = json |> member "similarSearch" |> to_list |>
         similarSearch_helper; date_search_data = json |> member
         "data_search_data" |> to_list |> date_search_data_helper; statusCode =
         json |> member "statusCode" |> to_int; *);
  }

let rec searchedRouteList_helper lst =
  match lst with
  | [] -> []
  | h :: t -> searchedRouteList_of_json h :: searchedRouteList_helper t

let from_json json =
  {
    searchedRouteList =
      json |> member "searchedRouteList" |> searchedRouteList_of_json
      (* typeType = json |> member "typeType" |> to_string; numberOfAdults =
         json |> member "numberOfAdluts" |> to_string; date_month = json |>
         member "date_month" |> to_string; dateMonthType = json |> member
         "dateMonthType" |> to_string; *);
  }

(******************************************************)
let search_to_important = List.fold_left (fun acc h -> h.importantinfo) []

let get_price route =
  let rec price_helper acc lst =
    match lst with
    | [] -> []
    | h :: t ->
        (h.pass_amount +. h.booking_fee +. h.facility_fee) :: price_helper acc t
  in
  price_helper [] route.searchedRouteList.importantinfo

let date h =
  let m_d_y =
    [
      String.sub h.travel_date 5 2;
      String.sub h.travel_date 8 2;
      String.sub h.travel_date 0 4;
    ]
  in
  String.concat "/" m_d_y

let notes loc =
  match loc.src_stop_name with
  | "New York, NY" | "Ithaca, NY" ->
      String.sub loc.src_landmark 0 (String.index_from loc.src_landmark 0 '-')
  | "Binghamton, NY" -> "Greater Binghamton Bus Terminal"
  | "Syracuse, NY" ->
      let x = loc.src_landmark in
      if String.sub x 0 4 = "Wave" then "Waverly Ave.   "
      else "Destiny USA Mall"
  | _ -> loc.src_landmark

let note loc =
  match loc.dest_stop_name with
  | "New York, NY" | "Ithaca, NY" ->
      String.sub loc.dest_landmark 0 (String.index_from loc.dest_landmark 0 '-')
  | "Binghamton, NY" -> "Greater Binghamton Bus Terminal"
  | "Syracuse, NY" ->
      let x = loc.dest_landmark in
      if String.sub x 0 4 = "Wave" then "Waverly Ave.   "
      else "Destiny USA Mall"
  | _ -> loc.dest_landmark

let get_info route =
  let rec info_helper acc lst =
    match lst with
    | [] -> acc
    | h :: t ->
        [
          h.src_stop_name;
          h.dest_stop_name;
          date h;
          String.sub h.src_stop_eta 0 5;
          String.sub h.dest_stop_eta 0 5;
          String.concat ""
            [
              "$";
              (let x =
                 string_of_float
                   (h.pass_amount +. h.booking_fee +. h.facility_fee)
               in
               if String.length x = 5 then x else x ^ "0");
            ];
        ]
        :: info_helper acc t
  in
  info_helper [] route.searchedRouteList.importantinfo

type journey = {
  from : string;
  destination : string;
  month : int;
  date : int;
  year : int;
  price : float;
  timedepart : string;
  timearrive : string;
}

type vehicle = {
  company : string;
  path : journey list;
}

let parse_json json q =
  let route = from_json json in
  let rec parse_json_helper acc lst =
    match lst with
    | [] -> acc
    | h :: t ->
        {
          from = h.src_stop_name;
          destination = h.dest_stop_name;
          month = int_of_string (String.sub h.travel_date 5 2);
          date = int_of_string (String.sub h.travel_date 8 2);
          year = int_of_string (String.sub h.travel_date 0 4);
          price = h.pass_amount +. h.booking_fee +. h.facility_fee;
          timedepart = String.sub h.src_stop_eta 0 5;
          timearrive = String.sub h.dest_stop_eta 0 5;
        }
        :: parse_json_helper acc t
  in
  {
    company = "Ourbus";
    path = parse_json_helper [] route.searchedRouteList.importantinfo;
  }
