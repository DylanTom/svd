(** Representation of static bus route data.

    This module represents the data stored in bus route files, including start
    and end destinations, and time. It handles the loading of that data from
    JSON as well as querying the data.

    For examples, the specifications in this interface reference the example bus
    query found in [test_data/bus.json].*)

type t
(** The abstract type of values representing all valid bus routes from each
    company. *)

val from_json : Yojson.Basic.t -> t
(** [from_json j] is the bus routes that [j] represents.

    Requires: [j] is a valid JSON bus routes representation. *)
