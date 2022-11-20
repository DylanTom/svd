open ANSITerminal
open Printf
open Svd
open Megabus
open Inputvalidate
open Printf

let cities =
  [ "NYC"; "ITH"; "BOS"; "CHI"; "ATL"; "MTL"; "TOR"; "LA"; "SF"; "EWR"; "DEN" ]

let inputs = Array.make 5 ""

let print_info () =
  if Inputvalidate.city inputs.(0) && Inputvalidate.city inputs.(1) then
    printf "\nBus From: %s \nBus To: %s" inputs.(0) inputs.(1)
  else printf "\nInvalid route";

  if Inputvalidate.date inputs.(2) inputs.(3) inputs.(4) then
    printf "\nDate of Travel: %s/%s/%s\n" inputs.(2) inputs.(3) inputs.(4)
  else printf "\nInvalid Date\n"

let rec match_city city flag =
  if Inputvalidate.city city then inputs.(flag) <- String.uppercase_ascii city
  else begin

    print_endline "\nYou entered a non-valid destination, please try again:";
    print_string [] "> ";
    match read_line () with
    | exception End_of_file -> ()
    | bus_from -> match_city bus_from flag

  end

let rec match_month m =

  try begin
    if Inputvalidate.valid_month m then inputs.(2) <- m

    else begin
      print_endline "\nYou entered an invalid month, please try again:";
      print_string [] "> ";
      match read_line () with
      | exception End_of_file -> ()
      | m -> match_month m
    end
  end
  with Failure _ -> begin
    print_endline "\nYou entered an invalid month, please try again:";
      print_string [] "> ";
      match read_line () with
      | exception End_of_file -> ()
      | m -> match_month m
  end

let rec match_day m d = 
  try begin
    if Inputvalidate.valid_day m d then inputs.(3) <- d
    else 
      begin
        print_endline "\nYou entered an invalid day, please try again:";
        print_string [] "> ";
        match read_line () with
        | exception End_of_file -> ()
        | d -> match_day m d
      end
  end
with Failure _ -> begin
  print_endline "\nYou entered an invalid day, please try again:";
        print_string [] "> ";
        match read_line () with
        | exception End_of_file -> ()
        | d -> match_day m d
end

let rec match_year y = 
  try begin
    if Inputvalidate.valid_year y then inputs.(4) <- y
    else 
      begin
        print_endline "\nYou entered an invalid year, please try again:";
        print_string [] "> ";
        match read_line () with
        | exception End_of_file -> ()
        | y -> match_year y
      end
  end
  with Failure _ -> begin
    print_endline "\nYou entered an invalid year, please try again:";
          print_string [] "> ";
          match read_line () with
          | exception End_of_file -> ()
          | y -> match_year y
  end

let rec input_handler () = 
  (* Bus From *)
  print_endline "\nPlease enter the origin you are coming from:";
  print_string [] "> ";
  match read_line () with
  | exception End_of_file -> ()
  | bus_from -> (
      match_city (String.trim bus_from) 0;

      (* Bus To *)
      print_endline "\nPlease enter the destination you want to go to:";

      print_string [] "> ";

      match read_line () with
      | exception End_of_file -> ()
      | bus_to -> (
          match_city (String.trim bus_to) 1;

          (* Month *)
          print_endline "\nPlease enter the month of your travel:";

          print_string [] "> ";

          match read_line () with
          | exception End_of_file -> ()
          | m -> (

              match_month m;


              (* Date *)
              print_endline "\nPlease enter the date of your travel:";

              print_string [] "> ";

              match read_line () with
              | exception End_of_file -> ()
              | date -> (
                  match_day inputs.(2) date;

                  (* Year *)
                  print_endline "\nPlease enter the year of your travel:";

                  print_string [] "> ";

                  match read_line () with
                  | exception End_of_file -> ()
                  | year ->
                      match_year year;
                      
                      ANSITerminal.print_string [ ANSITerminal.cyan ]
                      "\nThis is what you inputted. Is this correct? \n";
                      print_info ();
                      ANSITerminal.print_string [ ANSITerminal.cyan ]
                      "\nYES, this is correct. Please make the query. \nNO, this is incorrect, please redo.\n";
                      print_string [] "> [Y/N] ";
                      match read_line () with
                      | "Y" | "YES" | "y" | "Yes" -> print_string [] "SUCCESS!"
                      | "N" | "NO" | "n" | "No" -> input_handler () 
                      | _ -> print_string [] "Invalid token"
                      ))))


(** [main ()] prompts for Expedia to start*)
let main () =
  ANSITerminal.print_string [ ANSITerminal.red ]
    "Welcome to Expedia for buses!\nThe suggested cities to travel to and from are:\n\t";


  ANSITerminal.print_string [ ANSITerminal.red ]

    (String.concat " " cities ^ "\n");

  input_handler ()
  


(* Execute the game engine. *)
let () = main ()