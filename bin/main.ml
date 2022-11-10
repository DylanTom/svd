open ANSITerminal
open Printf
open Svd
open Megabus
open Inputvalidate
open Printf


exception UnknownCity of string

let cities = [ "NYC"; "ITH"; "BOS"; "CHI"; "ATL"; "MTL"; "TOR"; "LA"; "SF"; "EWR"; "DEN" ]
let inputs = Array.make 5 ""
(* let rec print_list = function [] -> ()
  |e::l -> print_string e; print_string " "; print_list l *)

let print_info () = 
  if (Inputvalidate.city inputs.(0) && Inputvalidate.city inputs.(1))  then printf "\nBus From: %s \nBus To: %s" inputs.(0) inputs.(1)
    else printf "\nInvalid route";
  if (Inputvalidate.date inputs.(2) inputs.(3) inputs.(4)) then
    printf "\nDate of Travel: %s/%s/%s\n" inputs.(2) inputs.(3) inputs.(4)
  else
    printf "\nInvalid Date\n"

(** [main ()] prompts for Expedia to start*)
let main () =
  ANSITerminal.print_string [ ANSITerminal.red ]
    "Welcome to Expedia for buses!
      The suggested cities to travel to and from are:\n\t";
    
  ANSITerminal.print_string [ ANSITerminal.red ] (String.concat " " cities);

  (* Bus From *)
  print_endline "\nPlease enter the destination you are coming from:";
  print_string [] "> ";
  match read_line () with
  | exception End_of_file -> ()
  | bus_from -> inputs.(0) <- String.uppercase_ascii bus_from;

  (* Bus To *)
  print_endline "\nPlease enter the destination you want to go to:";
  print_string [] "> ";
  match read_line () with
  | exception End_of_file -> ()
  | bus_to -> inputs.(1) <- String.uppercase_ascii bus_to;

  (* Month *)
  print_endline "\nPlease enter the month of your travel:";
  print_string [] "> ";
  match read_line () with
  | exception End_of_file -> ()
  | month -> inputs.(2) <- month;

  (* Date *)
  print_endline "\nPlease enter the date of your travel:";
  print_string [] "> ";
  match read_line () with
  | exception End_of_file -> ()
  | date -> inputs.(3) <- date;

  (* Year *)
  print_endline "\nPlease enter the year of your travel:";
  print_string [] "> ";
  match read_line () with
  | exception End_of_file -> ()
  | year -> inputs.(4) <- year;

  ANSITerminal.print_string [ ANSITerminal.cyan ]
    "\nThis is what you inputted. Is this correct?";
  print_info ();

  print_string [] "[Y/N] > ";
  match read_line () with
  | exception End_of_file -> ()
  | s -> ()
  (* run (make_query "2022-11-13" "123" "511") *)

(* Execute the game engine. *)
let () = main ()