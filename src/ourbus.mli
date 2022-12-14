(** Representation of an Ourbus query.

    This module represents the data stored in a GET API request. It handles the
    JSON returned from making a query based on input parameters. *)

type query
(** The abstract type representing the GET request of an Ourbus query *)

val make_query : string -> string -> string -> query
(** [make_query date dest orig] returns a query with [departureDate],
    [destinationID], and [originID] updated appropriately.

    Requires: [departureDate] is a valid date, [destinationID] is a valid city
    ID in the Ourbus API, [originID] is a valid city ID in the Ourbus API *)

val run_parser : query -> int
(* [run_parser url] runs a query to Ourbus given a [url]. It calls
   "script/parse_web.py" as a helper function. *)

type t 

val from_json : Yojson.Basic.t -> t
val get_price: t -> float list
val get_info : t -> string list list
