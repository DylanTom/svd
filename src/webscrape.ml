open Mechaml
module M = Agent.Monad
open M.Syntax

let require msg = function
  | Some a -> a
  | None -> failwith msg

let search =
  let* response = Agent.get "https://us.megabus.com/" in
  let form =
    response |> Agent.HttpResponse.page
    |> Page.form_with "[action$=search]"
    |> require "search form not found"
  in
  let field =
    form |> Page.Form.field_with "[name=q]" |> require "q feld not found"
  in
  let form = Page.Form.Field.set form field "module Form" in
  let* response = Agent.submit form in
  response |> Agent.HttpResponse.content
  |> M.save_content "./data/megabus-search-result.html"

let _ = M.run (Agent.init ()) search
