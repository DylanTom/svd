open OUnit2
open Svd
open Megabus
open Inputvalidate

(******************************************************************************)

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

let make_query_test (name : string) (expected_output : string)
    (input_fn : query -> string) (date : string) (dest : string)
    (origin : string) : test =
  name >:: fun _ ->
  assert_equal expected_output (make_query date dest origin |> input_fn)

let make_query_tests =
  [
    make_query_test "make query departure date" "2022-10-21" get_departure_date
      "2022-10-21" "123" "511";
    make_query_test "make query origin" "511" get_orig "2022-10-21" "123" "511";
    make_query_test "make query destination" "123" get_dest "2022-10-21" "123"
      "511";
  ]

(******************************************************************************)

let tests =
  "svd test suite" >::: List.flatten [ input_validate_tests; make_query_tests ]

let run_test = run (make_query "2022-12-16" "123" "511")

let _ = run_test_tt_main tests; run_test
