open Mechaml
module M = Agent.Monad
open M.Infix

let require msg = function
  | Some a -> a
  | None -> failwith msg

let search =
  Agent.get "https://us.megabus.com/"
  >|= (fun result ->
        let form =
          result |> Agent.HttpResponse.page
          |> Page.form_with "[action$=search]"
          |> require "search form not found"
        in
        let field =
          form |> Page.Form.field_with "[name=q]" |> require "q feld not found"
        in
        Page.Form.Field.set form field "module Form")
  >>= Agent.submit
  >>= fun response ->
  response |> Agent.HttpResponse.content
  |> M.save_content "megabus-search-result.html"

let _ = M.run (Agent.init ()) search
