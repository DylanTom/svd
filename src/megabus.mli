(** Representation of a Megabus query.

    This module represents the data stored in a GET API request. It handles the
    JSON returned from making a query based on input parameters. *)

type query
(** The abstract type representing the GET request of a Megabus query *)

val get_departure_date : query -> string
(** [get_departure_date q] returns the departure date stored in a query *)

val get_dest : query -> string
(** [get_dest q] returns the destination ID stored in a query *)

val get_orig : query -> string
(** [get_orig q] returns the origin ID stored in a query *)

val make_query : string -> string -> string -> query
(** [make_query date dest orig] returns a query with [departureDate],
    [destinationID], and [originID] updated appropriately.

    Requires: [departureDate] is a valid date, [destinationID] is a valid city
    ID in the Megabus API, [originID] is a valid city ID in the Megabus API *)

val run : query -> unit
(** [run q] executes a query to the Megabus API using the supplied query [q].
    Stores this file in a JSON file in the data subdirectory *)

type t
(** The abstract type representing the OCaml representation of a Megabus JSON *)

type vehicle
(** The abstract type representing the OCaml representation of a Megabus route
    list *)

val from_json : Yojson.Basic.t -> t
(** [from_json j] returns a parsed JSON of type t from a Yojson object. This
    specifically maps Megabus output to the return type that is needed. *)

val get_price : t -> float list
(** [get_price j] returns a float list of prices of all bus routes on a given
    output from Megabus. *)

val get_info : t -> string list list
(** [get_info j] returns a list of list of outputs which indicate origin,
    destination, departure, arrival, and price. This information is required for
    user display in the terminal *)

val parse_json : Yojson.Basic.t -> query -> vehicle
(** [parse_json j q] converts a JSON object to a type that can be later merged
    with other bus companies. This allows us to begin merging with the code from
    [bus.ml] *)
