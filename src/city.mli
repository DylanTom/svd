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
(** [output_cities j] returns a list of cities in [j]. Requires that [j] is a
    valid city JSON format. *)

val megabus_of_city : string -> t -> int
(** [megabus_of_city c t] returns the integer mapping of the inputted city [c]
    to its megabus code based on the parsed JSON. *)

val ourbus_of_city : string -> t -> string
(** [ourbus_of_city c t] returns the string mapping of the inputted city [c] to
    its ourbus code based on the parsed JSON. *)
