module type AuthorSig = sig
  val hours_worked : int
end

(* module AuthorCheck : AuthorSig = Author

   let _ = if Author.hours_worked < 0 then exit 1 *)
