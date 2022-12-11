(** Representation of a city parser.

    We are given a JSON of valid cities which can be updated. We parse this into
    a structure that can be interpreted and used in OCaml. *)

type city
(** The abstract type of a city with current support for Megabus and Ourbus *)

type t
(** The abstract type for the city JSON *)

val from_json : Yojson.Basic.t -> t
(** [from_json j] returns the OCaml representation of a city JSON. *)

val output_cities : t -> string list

val megabus_of_city : string -> t -> int
val ourbus_of_city : string -> t -> string
