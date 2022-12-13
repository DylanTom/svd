(** Testing Plan

    Our tests mainly focused on the verification of validators specifically in
    the [Inputvalidate], [City], [Megabus], and [Ourbus] modules. The main
    reason for this was because the main functionality of our system comes from
    interaction with the terminal. It is very difficult to test functions
    located in "bin/main.ml" as most return type unit.

    This test suite demonstrates understanding of the requirements necessary to
    prove the majority of our functions correct. We have automatic unit tests
    covering:

    - input validation of cities, months, days, years, and dates
    - query validation, specifically with making a valid query to Megabus and
      Ourbus
    - city validation of converting cities to its int representation for Megabus
      and string representation for Ourbus

    Test cases were developed using both a black box and glass box approach. For
    the majority of functions, we followed the specification to construct tests
    for boundary cases. Then, we ensured 100% bisect coverage as the method for
    glass box testing. We believe that this achieved full correctness as it
    covered many different user inputs that could still be valid and also
    ensured that different items were validated correctly.

    There was a significant amount of manual terminal testing that had to be
    done. In hindsight, this could have been automated but with the amount of
    changes we went through we decided it was in our best interest to manually
    test the terminal but automate our verification to ensure nothing broke in
    development. *)

open OUnit2
open Svd
open Megabus
open Inputvalidate
open Ourbus

(******************************************************************************)
(** INPUT VALIDATE TESTS **)

let input_validate_city_test (name : string) (expected_output : bool)
    (input : string) : test =
  name >:: fun _ -> assert_equal expected_output (valid_city input)

let input_validate_month_test (name : string) (expected_output : bool)
    (input : string) : test =
  name >:: fun _ -> assert_equal expected_output (valid_month input)

let input_validate_day_test (name : string) (expected_output : bool)
    (month : string) (day : string) : test =
  name >:: fun _ -> assert_equal expected_output (valid_day month day)

let input_validate_year_test (name : string) (expected_output : bool)
    (input : string) : test =
  name >:: fun _ -> assert_equal expected_output (valid_year input)

let input_validate_date_test (name : string) (expected_output : bool)
    (m : string) (d : string) (y : string) : test =
  name >:: fun _ -> assert_equal expected_output (valid_date m d y)

let input_validate_tests =
  [
    input_validate_city_test "validate city 1" true "NYC";
    input_validate_city_test "validate city 2" true "nYc";
    input_validate_city_test "validate city 3" true "nyc";
    input_validate_city_test "validate city 4" true "BoS";
    input_validate_city_test "validate city 5" true "    Ith ";
    input_validate_city_test "validate city 6" false "svd";
    input_validate_city_test "validate city 7" false "123";
    input_validate_city_test "validate city 8" false "";
    input_validate_month_test "valid month" true "2";
    input_validate_month_test "invalid month" false "0";
    input_validate_month_test "invalid month" false "13";
    input_validate_month_test "non-string" false "hi";
    input_validate_day_test "valid day 1" true "2" "1";
    input_validate_day_test "non int string" false "2" "undefined";
    input_validate_day_test "invalid day" false "2" "0";
    input_validate_day_test "valid day 2" true "3" "21";
    input_validate_day_test "valid day 3" false "3" "40";
    input_validate_year_test "valid year" true "2023";
    input_validate_year_test "valid year" false "dylan";
    input_validate_date_test "invalid year" false "vanessa" "sydney" "-2";
    input_validate_date_test "invalid year" false "vanessa" "sydney" "dylan";
    input_validate_date_test "invalid year" false "2" "29" "2022";
    input_validate_date_test "invalid year" true "2" "29" "2020";
    input_validate_date_test "invalid year" true "11" "13" "2023";
    input_validate_date_test "invalid year" false "13" "29" "2020";
  ]

(******************************************************************************)
(** MEGABUS MAKE QUERY TESTS **)

let make_query_test (name : string) (expected_output : string)
    (input_fn : Megabus.query -> string) (date : string) (dest : string)
    (origin : string) : test =
  name >:: fun _ ->
  assert_equal expected_output (Megabus.make_query date dest origin |> input_fn)

let make_query_tests =
  [
    make_query_test "make query departure date" "2022-10-21"
      Megabus.get_departure_date "2022-10-21" "123" "511";
    make_query_test "make query origin" "511" Megabus.get_orig "2022-10-21"
      "123" "511";
    make_query_test "make query destination" "123" Megabus.get_dest "2022-10-21"
      "123" "511";
  ]

(******************************************************************************)

(** CITY CONVERSION VALIDATE TESTS **)
let data_dir_prefix = "data" ^ Filename.dir_sep

let cities = Yojson.Basic.from_file (data_dir_prefix ^ "cities.json")

let megabus_city_test (name : string) (expected_output : int) (input : string) :
    test =
  name >:: fun _ ->
  assert_equal expected_output
    (City.megabus_of_city input (City.from_json cities))

let ourbus_city_test (name : string) (expected_output : string) (input : string)
    : test =
  name >:: fun _ ->
  assert_equal expected_output
    (City.ourbus_of_city input (City.from_json cities))

let city_validate_tests =
  [
    megabus_city_test "NYC" 123 "NYC";
    megabus_city_test "ITH" 511 "ITH";
    ourbus_city_test "NYC" "New%20York,%20NY" "NYC";
    ourbus_city_test "ITH" "Ithaca,%20NY" "ITH";
  ]

(******************************************************************************)

(** GENERAL TESTS **)
let data_dir_prefix = "data" ^ Filename.dir_sep

let megabus = Yojson.Basic.from_file (data_dir_prefix ^ "megabus.json")

let test_test =
  [
    ( "test" >:: fun _ ->
      assert_equal
        [ 71.88; 44.99; 44.99; 44.99; 47.99; 47.99; 47.99 ]
        (Megabus.get_price (Megabus.from_json megabus)) );
  ]

let tests =
  "svd test suite"
  >::: List.flatten
         [ input_validate_tests; make_query_tests; city_validate_tests ]

(******************************************************************************)
(** UNIT TESTERS **)

let run_test = Megabus.run (Megabus.make_query "2022-12-16" "123" "511")

let run_test_2 =
  [
    ( "Ourbus Python Script" >:: fun _ ->
      assert_equal 3 Ourbus.run_parser ~printer:string_of_int );
  ]

(******************************************************************************)
(** MAIN TEST **)
(******************************************************************************)

let _ =
  run_test_tt_main tests;
  run_test;
  run_test_2
