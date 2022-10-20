open OUnit2
open Svd
open Megabus

(* let q' =
  {
    days = "1";
    concessionCount = "0";
    departureDate = "2022-10-21";
    destinationId = "123";
    inboundPcaCount = "0";
    inboundOtherDisabilityCount = "0";
    inboundWheelchairSeated = "0";
    nusCount = "0";
    originId = "511";
    otherDisabilityCount = "0";
    pcaCount = "0";
    totalPassengers = "1";
    wheelchairSeated = "0";
  } *)

let tests =
  "svd test suite"
  >::: [
         (* ( "make query" >:: fun _ ->
           assert_equal q' (make_query "2022-10-21" "123" "511") ); *)
       ]

let _ = run_test_tt_main tests