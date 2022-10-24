open OUnit2
open Svd
open Megabus

let tests =
  "svd test suite"
  >::: [
         ( "make query departure date" >:: fun _ ->
           assert_equal "2022-10-21"
             (make_query "2022-10-21" "123" "511" |> get_departure_date) );
         ( "make query destination" >:: fun _ ->
           assert_equal "123" (make_query "2022-10-21" "123" "511" |> get_dest)
         );
         ( "make query origin" >:: fun _ ->
           assert_equal "511" (make_query "2022-10-21" "123" "511" |> get_orig)
         );
       ]

let _ = run_test_tt_main tests
