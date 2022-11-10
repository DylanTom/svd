open OUnit2
open Svd
open Megabus
open Inputvalidate

let input_validate_test (name : string) (expected_output : bool)
    (input_fn : string -> bool) (input : string) : test =
  name >:: fun _ -> assert_equal expected_output (input_fn input)

let input_validate_tests =
  [
    input_validate_test "validate city" true city "NYC";
    input_validate_test "validate city" true city "nYc";
    input_validate_test "validate city" true city "nyc";
    input_validate_test "validate city" true city "BoS";
    input_validate_test "validate city" false city "svd";
    input_validate_test "validate city" false city "123";
    input_validate_test "validate city" false city "";
  ]

let tests =
  "svd test suite"
  >::: List.flatten
         [
           input_validate_tests;
           [
             ( "make query departure date" >:: fun _ ->
               assert_equal "2022-10-21"
                 (make_query "2022-10-21" "123" "511" |> get_departure_date) );
             ( "make query destination" >:: fun _ ->
               assert_equal "123"
                 (make_query "2022-10-21" "123" "511" |> get_dest) );
             ( "make query origin" >:: fun _ ->
               assert_equal "511"
                 (make_query "2022-10-21" "123" "511" |> get_orig) );
           ];
         ]

let _ = run_test_tt_main tests
