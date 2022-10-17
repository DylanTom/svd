open Yojson.Basic.Util

(* The type representing a specific route. Requires: [from] : 3 letter code
   representing the origin, [destination] : 3 letter code representing the
   destination, [month] : 1..12, [day] : 0..31, [year] : year >= 0, [url] : link
   to the specific route *)
type route = {
  from : string;
  destination : string;
  month : int;
  day : int;
  year : int;
  price : float;
  url : string;
}

(* The type representing an entry into buses by company *)
type entry = {
  company : string;
  route : route list;
}

type buses = { routes : entry list }