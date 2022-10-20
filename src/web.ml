open Mechaml
module M = Agent.Monad
open M.Infix

let require msg = function
  | Some a -> a
  | None -> failwith msg

let action_login =
  Agent.get "https://www.google.com"
  >|= (fun response ->
    response
    |> Agent.HttpResponse.page
    |> Page.form_with "[title=Search]"
    |> require "Can't find the login form !"
    |> Page.Form.set "hi" "hi")
  >>= Agent.submit
  >>= (fun response ->
    response
    |> Agent.HttpResponse.content
    |> M.save_content "./data/google.html")

let _ =
  M.run (Agent.init ()) action_login