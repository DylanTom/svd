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
(** [from_json j] is the bus routes that [j] represents. Requires: [j] is a
    valid JSON bus routes representation. *)

val find_company : string -> t list -> t 
(** [find_company company lst] is a recursive function that takes the inputs
    [company lst]. It will raise an UnknownCompany exception if the company is
    not in the list. If it does exist in the list, it return the company in json
    format.*)

(** [route_from_list] is a recursive function that takes the input [lst] of type
    buses list and outputs a list of the route from type with the type string
    list*)

(** [route_destination_list] is a recursive function that takes the input [lst]
    of type buses list and outputs a list of the route destination type with the
    type string list*)

(** [get_possible_dates] is a recursive function that takes in the inputs
    [route_from_list route_destination_list]. It checks if the specific
    route_from and route_destination exists. if it does, return the list of
    possible dates. if false, raise UnknownRoute exception.*)

(** [check_date] takes in the inputs [date possible_dates]. It checks if the
    specific date is in the list of possible dates. if false, raise UnknownRoute
    exception*)

(** [get_times] takes in the inputs [route date]. It returns the timeleave and
    time arrive of the valide bus route.*)

(** [get_price] takes in the inputs [route date time]. It returns the price and
    the url to the bus ticket.*)