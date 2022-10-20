type query

val get_departure_date : query -> string
val get_dest : query -> string
val get_orig : query -> string
val make_query : string -> string -> string -> query
val get_uri : query -> string
val run : unit -> unit
