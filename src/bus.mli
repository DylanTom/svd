(** Representation of static bus route data.

    This module represents the data stored in bus route files, including start
    and end destinations, and time. It handles the loading of that data from
    JSON as well as querying the data.

    For examples, the specifications in this interface reference the example bus
    query found in [test_data/bus.json].*)

type route
(** The type of values representing individual bus routes. *)

type bus
(** The type of values representing all bus routes for individual companies. *)

type t
(** The abstract type of values representing all valid bus routes from each
    company. *)
