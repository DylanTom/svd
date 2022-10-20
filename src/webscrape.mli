(** Representation of webcscrape data.

    This module represents the data stored in webscrape files. It handles the
    scraping of web data from the megabus website. *)

val require : string -> 'a option -> 'a
val search : unit Mechaml.Agent.Monad.m
