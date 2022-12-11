(** Representation of an Ourbus query.

    This module represents the data stored in a GET API request. It handles the
    JSON returned from making a query based on input parameters. *)

(* type query *)
(** The abstract type representing the GET request of a Megabus query *)

val run_parser : int
(* [run_parser url] runs a query to Ourbus given a [url]. It calls
   "script/parse_web.py" as a helper function. *)
