open ANSITerminal
open Printf
open Svd
open Megabus
open Inputvalidate

(* 
exception UnknownCity of string

let cities =
  [ "NYC"; "ITH"; "BOS"; "CHI"; "ATL"; "MTL"; "TOR"; "LA"; "SF"; "EWR"; "DEN" ]

let inputs = Array.make 5 ""

let rec check_city index = 
  print_endline "> "; 
  match read_line () with
  | exception End_of_file -> ()
  | city -> 
      let rec find_city city cities = 
        match cities with 
        | [] ->printf "\n%s is an invalid city. Enter a valid city:" city; check_city index
        | h :: t -> if h = String.uppercase_ascii city then find_city city t else inputs.(index) <- String.uppercase_ascii city;  
      
      
let check_date month day = 
  match month with
  | "02" -> 1 <= day && d <= 28
  | "04" | "06" | "09" | "11" -> 1 <= d && d <= 30
  | "01" | "03" | "05" | "07" | "08" | "10" | "12" -> 1 <= day && day <= 31
  | _ -> false
        

let get_inputs = 
  ANSITerminal.print_string [ ANSITerminal.blue ]
    "Welcome to Expedia for buses!\n\
     The suggested cities to travel to and from are: \n";
  List.iter (printf "%s ") cities;
  
  (* Bus From *)
  print_endline "\n\nPlease enter the destination you are coming from:";
  (* print_endline "> "; *)
  (* match read_line () with
  | exception End_of_file -> ()
  | bus_from -> inputs.(0) <- String.uppercase_ascii bus_from;  *)
  check_city 0;
    

  (* Bus To *)
  print_endline "\nPlease enter the destination you want to go to:";
  (* print_endline "> ";
  match read_line () with
  | exception End_of_file -> ()
  | bus_to -> inputs.(1) <- String.uppercase_ascii bus_to; *)
  check_city 1;

  (* Month *)
  print_endline "\nPlease enter the month of your travel: (MM)";
  print_endline "> ";
  match read_line () with
  | exception End_of_file -> ()
  | month -> inputs.(2) <- month;

  (* Date *)
  print_endline "\nPlease enter the date of your travel: (DD)";
  print_endline "> ";
  match read_line () with
  | exception End_of_file -> ()
  | date -> inputs.(3) <- date;

  (* Year *)
  print_endline "\nPlease enter the year of your travel: (YYYY)";
  print_endline "> ";
  match read_line () with
  | exception End_of_file -> ()
  | year -> inputs.(4) <- year;

  (* Print the Array *)
  printf "\nBus From: %s \nBus To: %s" inputs.(0) inputs.(1);
  printf "\nDate of Travel: %s/%s/%s\n" inputs.(2) inputs.(3) inputs.(4)

(** [main ()] prompts for Expedia to start*)
let main () =
  get_inputs 
  

(* Execute the game engine. *)
let () = main () *)

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
      The suggested cities to travel to and from are:
      NYC ITH BOS CHI ALT MTL TOR LA SF EWR DEN";

  (* Bus From *)
  print_endline "\nPlease enter the destination you are coming from:";
  print_endline "> ";
  match read_line () with
  | exception End_of_file -> ()
  | bus_from -> inputs.(0) <- String.uppercase_ascii bus_from;

  (* Bus To *)
  print_endline "\nPlease enter the destination you want to go to:";
  print_endline "> ";
  match read_line () with
  | exception End_of_file -> ()
  | bus_to -> inputs.(1) <- String.uppercase_ascii bus_to;

  (* Month *)
  print_endline "\nPlease enter the month of your travel:";
  print_endline "> ";
  match read_line () with
  | exception End_of_file -> ()
  | month -> inputs.(2) <- month;

  (* Date *)
  print_endline "\nPlease enter the date of your travel:";
  print_endline "> ";
  match read_line () with
  | exception End_of_file -> ()
  | date -> inputs.(3) <- date;

  (* Year *)
  print_endline "\nPlease enter the year of your travel:";
  print_endline "> ";
  match read_line () with
  | exception End_of_file -> ()
  | year -> inputs.(4) <- year;

  print_info ();
  run (make_query "2022-11-13" "123" "511")

(* Execute the game engine. *)
let () = main ()