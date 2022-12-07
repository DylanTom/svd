open Svd

module type AuthorSig = sig
  val hours_worked : (string * int) list
end

module AuthorCheck : AuthorSig = Author

module type BusSig = sig
  type t

  exception UnknownCompany of string
  exception UnknownCity of string

  val from_json : Yojson.Basic.t -> t
  val find_company : string -> t -> t
  val route_from_list : t -> string list
  val route_destination_list : t -> string list
  val get_possible_dates : string list -> string list -> string list
  val check_date : string -> string list -> bool
  val get_times : string list -> string -> string * string
  val get_price : string list -> string -> string -> float * string
end

module type ValidatorSig = sig
  val valid_cities : string list
  val valid_city : string -> bool
  val valid_month : string -> bool
  val valid_day : string -> string -> bool
  val valid_year : string -> bool
  val valid_date : string -> string -> string -> bool
end

module InputValidatorCheck : ValidatorSig = Inputvalidate

module type MegabusSig = sig
  type t
  type query

  val get_departure_date : query -> string
  val get_dest : query -> string
  val get_orig : query -> string
  val make_query : string -> string -> string -> query
  val run : query -> unit
  val from_json : Yojson.Basic.t -> t
  val get_price : t -> float list
  val parse_json : Yojson.Basic.t -> Yojson.Basic.t
end

module MegabusCheck : MegabusSig = Megabus

let verify_hours hours =
  let rec verify acc = function
    | [] -> acc
    | (_, v) :: t -> v > 0 && verify acc t
  in
  verify true hours


let _ = if verify_hours Author.hours_worked then exit 1
