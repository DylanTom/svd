(** Representation of static bus route data.

    This module represents the data stored in bus route files, including start
    and end destinations, and time. It handles the loading of that data from
    JSON as well as querying the data.

    For examples, the specifications in this interface reference the example bus
    query found in [test_data/bus.json]. *)
    
type route
(** The type of values representing a single bus route. *)

type buses
(** The type of values representing all routes for each company. *)
type t
(** The abstract type of values representing all valid bus routes from each
    company. *)

exception UnknownCompany of string
exception UnknownCity of string

val from_json : Yojson.Basic.t -> t
(** [from_json j] is the bus routes that [j] represents. Requires: [j] is a
    valid JSON bus routes representation. *)

val find_company : string -> t -> t
(** [find_company company lst] is a recursive function that takes the inputs
    [company lst]. It will raise an [UnknownCompany] exception if the company is
    not in the list. If it does exist in the list, it return the company in json
    format.*)

val route_from_list : t -> string -> string list
(** [route_from_list buses c] is a recursive function that takes the input
    [buses] of type t and outputs a list of the route from type with the type
    string list for company [c] *)

val route_destination_list : t -> string -> string list
(** [route_destination_list buses c] is a recursive function that takes the input
    [buses] of type buses list and outputs a list of the route destination type
    with the type string list [c]*)

val get_possible_dates : string list -> string list -> string list
(** [get_possible_dates route_from_list route_destination_list] is a recursive
    function that takes in the inputs [route_from_list route_destination_list].
    It checks if the specific route_from and route_destination exists. if it
    does, return the list of possible dates.

    If false, raises [UnknownRoute] exception.*)

val check_date : string -> string list -> bool
(** [check_date date possible_dates] takes in the inputs [date possible_dates].
    It checks if the specific date is in the list of possible dates.

    If false, raises [UnknownRoute] exception*)

val get_times : string list -> string -> string * string
(** [get_times route date] takes in the inputs [route date]. It returns the
    timeleave and time arrive of the valid bus route.*)

val get_price : string list -> string -> string -> float * string
(** [get_price route date time] takes in the inputs [route date time]. It
    returns the price and the url to the bus ticket. *)
