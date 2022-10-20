open Lwt
open Cohttp
open Cohttp_lwt_unix
open Core

let body =
  Client.get (Uri.of_string "https://us.megabus.com/") >>= fun (resp, body) ->
  let code = resp |> Response.status |> Code.code_of_status in
  Printf.printf "Response code: %d\n" code;
  Printf.printf "Headers: %s\n" (resp |> Response.headers |> Header.to_string);
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
  Printf.printf "Body of length: %d\n" (String.length body);
  body

let () =
  let body = Lwt_main.run body in
  Out_channel.write_all "your_file.txt" ~data:body