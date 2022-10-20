open Lwt
open Cohttp
open Cohttp_lwt_unix
open Core

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
      "concessionCount=" ^ q.concessionCount;
      "departureDate=" ^ q.departureDate;
      "destinationId=" ^ q.destinationId;
      "inboundPcaCount=" ^ q.inboundPcaCount;
      "inboundOtherDisabilityCount=" ^ q.inboundOtherDisabilityCount;
      "inboundWheelChairSeated=" ^ q.inboundWheelchairSeated;
      "nusCount=" ^ q.nusCount;
      "originId=" ^ q.originId;
      "otherDisabilityCount=" ^ q.otherDisabilityCount;
      "pcaCount=" ^ q.pcaCount;
      "totalPassengers=" ^ q.totalPassengers;
      "wheelchairSeated=" ^ q.wheelchairSeated;
    ]
  in
  let query_params = concat to_build in
  "https://us.megabus.com/journey-planner/api/journeys?" ^ query_params

let q = make_query "2022-10-21" "123" "511"

let body =
  Client.get (Uri.of_string (get_uri q)) >>= fun (resp, body) ->
  let code = resp |> Response.status |> Code.code_of_status in
  Printf.printf "Response code: %d\n" code;
  body |> Cohttp_lwt.Body.to_string >|= fun body -> body

let () =
  let body = Lwt_main.run body in
  Out_channel.write_all "./data/megabus.json" ~data:body