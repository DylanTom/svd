(** Representation of webcscrape data.

    This module represents the data stored in webscrape files. It handles the
    scraping of web data from the megabus website. *)

val require : string -> 'a option -> 'a
(** [require] returns the search form message for a Megabus query *)

val search : unit Mechaml.Agent.Monad.m
(** [search] returns an updated state of a Mechaml Monad Agent for the HTTP GET
    request and all valid forms of the selector message. *)
