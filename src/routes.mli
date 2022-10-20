(* Representation of a static route type. *)

type buses
(* The abstract type representing the routes *)

(* val parse_json : Yojson.Basic.t -> buses
(* [parse_json f] reads a JSON file and converts it to its representation in
   OCaml as type buses *)

val get_company : buses -> string
(* [get_company r] is the company of a route *)

val get_origin : buses -> string
(* [get_origin r] is the origin of a route *)

val get_destination : buses -> string
(* [get_destination r] is the destination of a route *)

val get_date : buses -> string
(* [get_date r] is the date of a route in mm/dd/yy format *)

val get_price : buses -> float
(* [get_price r] is the price of a route *)

val get_url : buses -> string
(* [get_url r] is the URL to the route *)

val price_url : buses -> (float * string) list
[price_url r] is a list of prices and URLs from the JSON *)