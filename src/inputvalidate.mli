val city : string -> bool
(* [city c] returns whether city is in the list of valid cities. Requires [c] to
   be a city in its 2 or 3 letter code. *)

val valid_month : string -> bool
(* [valid_month m] returns whether the month is a valid month between January
   and Decemeber. *)

val valid_day : string -> string -> bool
(* [valid_day m d] returns whether the day is a valid day given the month [m].
   Requires [m] is a valid_month as defined above. *)

val valid_year : string -> bool
(* [valid_year y] returns whether [y] is a valid year. Requires [y] >= 2022. *)

val date : string -> string -> string -> bool
(* [date m d y] returns whether [d] is a valid day in the valid month [m] given
   a year [y]. Important: Checks to make sure leap year is valid. This is a
   representative test case combining [valid_month], [valid_day],
   [valid_year]. *)
