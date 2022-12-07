open Mechaml
module M = Agent.Monad
open M.Infix

type query = {
  departureDate : string;
  destinationId : string;
  originId : string;
  totalPassengers : string;
}

let get_departure_date q = q.departureDate
let get_dest q = q.destinationId
let get_orig q = q.originId

let make_query dep_date dest ori =
  {
    departureDate = dep_date;
    destinationId = dest;
    originId = ori;
    totalPassengers = "1";
  }

let rec concat = function
  | [] -> ""
  | h :: t -> h ^ concat t

let get_uri q =
  let to_build =
    [
      "origin=" ^ q.originId;
      "&destination=" ^ q.destinationId;
      "&departure_date=" ^ q.departureDate;
      "&adult=" ^ q.totalPassengers;
    ]
  in
  let query_params = concat to_build in
  "https://www.ourbus.com/booknow?" ^ query_params

let require msg = function
  | Some a -> a
  | None -> failwith msg

(* type state =
  | Ok of string
  | Error of string * exn

let image_filename src =
  let last_slash =
    match String.rindex src '/' with
    | exception Not_found -> 0
    | i -> i + 1
  in
  String.sub src last_slash (String.length src - last_slash)

let save_images images =
  images
  |> M.List.map_p (fun img ->
         let path = Page.Image.source img |> image_filename |> ( ^ ) "/tmp/" in
         let save _ = Agent.save_image path img >> M.return (Ok path) in
         let handler e = Error (path, e) |> M.return in
         M.catch save handler)

let action_download =
  Agent.get "https://ocaml.org/index.fr.html"
  >|= (fun response ->
        response |> Agent.HttpResponse.page
        |> Page.images_with "[src$=.png]"
        |> Page.to_list)
  >>= save_images *)

let action_open q =
  q |> get_uri |> Agent.get >|= Agent.HttpResponse.page
  >|= (function
        | page ->
            page
            |> Page.form_with "[name=login]"
            |> require "Can't find the login form !"
            |> Page.Form.set "username" "mynick"
            |> Page.Form.set "password" "@xlz43")
  >>= Agent.submit


(* open Lwt
open Cohttp
open Cohttp_lwt_unix

let get_page url =
  (* Use the Cohttp_lwt_unix library to make an HTTP GET request to the given URL *)
  Client.get (Uri.of_string url) >>= fun (resp, body) ->

  (* Convert the response body to a string and return it *)
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
  body *)



(* Import the necessary modules
(* Define a function to make an HTTP GET request and return the response body as a string *)


(* Define a function to parse the HTML content of a web page *)
let parse_page html =
  (* Use the HTML parser of your choice to parse the HTML content and extract the desired information *)
  (* For example, you could use the OCaml-HTML parser to create an AST of the HTML page and traverse it to find the information you are looking for *)
  (* https://github.com/aantron/ocaml-html *)
  (* ... *)

(* Define a function to download and parse a web page *)
let download_and_parse url =
  (* Download the web page using the `get_page` function *)
  let page = get_page url in

  (* Parse the HTML content of the web page using the `parse_page` function *)
  

  (* Return the parsed page *)
  parsed_page

(* Use the `download_and_parse` function to download and parse a web page *)
let parsed_page = download_and_parse "https://www.example.com" *)

(* let run () =
  action_download
  |> M.run (Agent.init ())
  |> snd
  |> List.iter (function
       | Ok file -> Printf.printf "Image %s successfully downloaded\n" file
       | Error (file, e) ->
           e |> Printexc.to_string
           |> Printf.printf "Image %s : error (%s)\n" file) *)
