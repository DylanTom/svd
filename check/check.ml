open Svd 

module type AuthorSig = sig
  val hours_worked : int list
end

module AuthorCheck : AuthorSig = Author

let verify_hours = List.fold_left (fun acc elt -> acc && elt > 0) true

let _ = if (verify_hours Author.hours_worked) then exit 1