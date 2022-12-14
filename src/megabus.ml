open Lwt
open Cohttp
open Cohttp_lwt_unix
open Core
open Yojson
open Yojson.Basic
open Yojson.Basic.Util
open Core_unix
open Bus

type query = {
  days : string;
  concessionCount : string;
  departureDate : string;
  destinationId : string;
  inboundPcaCount : string;
  inboundOtherDisabilityCount : string;
  inboundWheelchairSeated : string;
  nusCount : string;
  originId : string;
  otherDisabilityCount : string;
  pcaCount : string;
  totalPassengers : string;
  wheelchairSeated : string;
}

let get_departure_date q = q.departureDate
let get_dest q = q.destinationId
let get_orig q = q.originId

let make_query dep_date dest ori =
  {
    days = "1";
    concessionCount = "0";
    departureDate = dep_date;
    destinationId = dest;
    inboundPcaCount = "0";
    inboundOtherDisabilityCount = "0";
    inboundWheelchairSeated = "0";
    nusCount = "0";
    originId = ori;
    otherDisabilityCount = "0";
    pcaCount = "0";
    totalPassengers = "1";
    wheelchairSeated = "0";
  }

let rec concat = function
  | [] -> ""
  | h :: t -> h ^ concat t

let get_uri q =
  let to_build =
    [
      "days=" ^ q.days;
      "&concessionCount=" ^ q.concessionCount;
      "&departureDate=" ^ q.departureDate;
      "&destinationId=" ^ q.destinationId;
      "&inboundPcaCount=" ^ q.inboundPcaCount;
      "&inboundOtherDisabilityCount=" ^ q.inboundOtherDisabilityCount;
      "&inboundWheelChairSeated=" ^ q.inboundWheelchairSeated;
      "&nusCount=" ^ q.nusCount;
      "&originId=" ^ q.originId;
      "&otherDisabilityCount=" ^ q.otherDisabilityCount;
      "&pcaCount=" ^ q.pcaCount;
      "&totalPassengers=" ^ q.totalPassengers;
      "&wheelchairSeated=" ^ q.wheelchairSeated;
    ]
  in
  let query_params = concat to_build in
  "https://us.megabus.com/journey-planner/api/journeys?" ^ query_params

let body q =
  Client.get (Uri.of_string (get_uri q)) >>= fun (resp, body) ->
  (* let code = resp |> Response.status |> Code.code_of_status in Printf.printf
     "Response code: %d\n" code; Printf.printf "Sucessfully queried. Data stored
     in data/megabus.json\n"; *)
  body |> Cohttp_lwt.Body.to_string >|= fun body -> body

let run q =
  let body = Lwt_main.run (body q) in
  (* let _ = Filename_unix.temp_file "test" "" in *)
  Out_channel.write_all "./data/megabus.json" ~data:body

(*****************************************************************************)

type city = {
  cityName : string;
  cityId : string;
  stopName : string;
  stopId : string;
}

type leg = {
  carrier : string;
  transportTypeId : int;
  departureDateTime : string;
  arrivalDateTime : string;
  duration : string;
  origin : city;
  destination : city;
  carrierIcon : string;
}

type journey = {
  journeyId : string;
  departureDateTime : string;
  arrivalDateTime : string;
  duration : string;
  price : float;
  origin : city;
  destination : city;
  legs : leg list;
  reservableType : string;
  serviceInformation : string;
  routeName : string;
  lowStockCount : Yojson.Basic.t;
  promotionCodeStatus : string;
}

type t = { journeys : journey list }

let city_of_json j =
  {
    cityName = j |> member "cityName" |> to_string;
    cityId = j |> member "cityId" |> to_string;
    stopName = j |> member "stopName" |> to_string;
    stopId = j |> member "stopId" |> to_string;
  }

let leg_of_json j =
  {
    carrier = j |> member "carrier" |> to_string;
    transportTypeId = j |> member "transportTypeId" |> to_int;
    departureDateTime = j |> member "departureDateTime" |> to_string;
    arrivalDateTime = j |> member "arrivalDateTime" |> to_string;
    duration = j |> member "duration" |> to_string;
    origin = j |> member "origin" |> city_of_json;
    destination = j |> member "destination" |> city_of_json;
    carrierIcon = j |> member "carrierIcon" |> to_string;
  }

let rec map_leg lst =
  match lst with
  | [] -> []
  | h :: t -> leg_of_json h :: map_leg t

let journey_of_json j =
  {
    journeyId = j |> member "journeyId" |> to_string;
    departureDateTime = j |> member "departureDateTime" |> to_string;
    arrivalDateTime = j |> member "arrivalDateTime" |> to_string;
    duration = j |> member "duration" |> to_string;
    price = j |> member "price" |> to_float;
    origin = j |> member "origin" |> city_of_json;
    destination = j |> member "destination" |> city_of_json;
    legs = j |> member "legs" |> to_list |> map_leg;
    reservableType = j |> member "reservableType" |> to_string;
    serviceInformation = j |> member "serviceInformation" |> to_string;
    routeName = j |> member "routeName" |> to_string;
    lowStockCount = j |> member "lowStockCount";
    promotionCodeStatus = j |> member "promotionCodeStatus" |> to_string;
  }

let rec map_journey lst =
  match lst with
  | [] -> []
  | h :: t -> journey_of_json h :: map_journey t

let from_json j =
  { journeys = j |> member "journeys" |> to_list |> map_journey }

(*****************************************************************************)

let get_price journey =
  let rec price_helper acc lst =
    match lst with
    | [] -> acc
    | h :: t -> h.price :: price_helper acc t
  in
  price_helper [] journey.journeys

let date h =
  let m_d_y =
    [
      String.sub h.departureDateTime 5 2;
      String.sub h.departureDateTime 8 2;
      String.sub h.departureDateTime 0 4;
    ]
  in
  String.concat ~sep:"/" m_d_y

let notes_helper loc =
  match loc.cityName with
  | "New York, NY" -> "Port Authority Bus Terminal"
  | "Ithaca, NY" -> (
      match String.index_from loc.stopName 0 '-' with
      | Some x -> String.sub loc.stopName 0 x
      | None -> failwith "impossible")
  | "Binghamton, NY" -> "Greater Binghamton Transportation Center"
  | "Syracuse, NY" -> "Syracuse Regional Transit Center"
  | _ -> loc.stopName

let get_info journey =
  let rec info_helper acc lst =
    match lst with
    | [] -> acc
    | h :: t ->
        [
          h.origin.cityName;
          h.destination.cityName;
          date h;
          String.sub h.departureDateTime 11 5;
          String.sub h.arrivalDateTime 11 5;
          String.concat
            [
              "$";
              (let x = string_of_float h.price in
               if String.length x = 5 then x else x ^ "0");
            ];
          notes_helper h.origin ^ "\t-->\t" ^ notes_helper h.destination;
        ]
        :: info_helper acc t
  in
  info_helper [] journey.journeys

type path = {
  from : string;
  destination : string;
  month : int;
  date : int;
  year : int;
  price : float;
  timeleave : string;
  timearrive : string;
  url : string;
}

type vehicle = {
  company : string;
  route : path list;
}

let parse_json j q =
  let journey = from_json j in
  let rec parse_json_helper acc lst =
    match lst with
    | [] -> acc
    | h :: t ->
        {
          from = h.origin.cityName;
          destination = h.destination.cityName;
          month = int_of_string (String.sub h.departureDateTime 5 2);
          date = int_of_string (String.sub h.departureDateTime 8 2);
          year = int_of_string (String.sub h.departureDateTime 0 4);
          price = h.price;
          timeleave = String.sub h.departureDateTime 11 8;
          timearrive = String.sub h.arrivalDateTime 11 8;
          url = get_uri q;
        }
        :: parse_json_helper acc t
  in
  { company = "Megabus"; route = parse_json_helper [] journey.journeys }

let map_date input =
  match input with
  | "1" -> "01"
  | "2" -> "02"
  | "3" -> "03"
  | "4" -> "04"
  | "5" -> "05"
  | "6" -> "06"
  | "7" -> "07"
  | "8" -> "08"
  | "9" -> "09"
  | s -> s

let map_month input =
  match input with
  | "1" -> "01"
  | "2" -> "02"
  | "3" -> "03"
  | "4" -> "04"
  | "5" -> "05"
  | "6" -> "06"
  | "7" -> "07"
  | "8" -> "08"
  | "9" -> "09"
  | s -> s