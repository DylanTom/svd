open ANSITerminal
open Printf
open Svd
open Megabus
open Inputvalidate
open Printf

let cities =
  [ "NYC"; "ITH"; "BOS"; "CHI"; "ATL"; "MTL"; "TOR"; "LA"; "SF"; "EWR"; "DEN" ]

let inputs = Array.make 5 ""
let data_dir_prefix = "data" ^ Filename.dir_sep

let print_info () =
  if Inputvalidate.valid_city inputs.(0) && Inputvalidate.valid_city inputs.(1)
  then printf "\nBus From: %s \nBus To: %s" inputs.(0) inputs.(1)
  else printf "\nInvalid route";

  if Inputvalidate.valid_date inputs.(2) inputs.(3) inputs.(4) then
    printf "\nDate of Travel: %s/%s/%s\n" inputs.(2) inputs.(3) inputs.(4)
  else printf "\nInvalid Date\n"

let rec match_city city flag =
  if Inputvalidate.valid_city city then
    inputs.(flag) <- String.uppercase_ascii city
  else begin
    print_endline "\nYou entered a non-valid destination, please try again:";
    print_string [] "> ";
    match read_line () with
    | exception End_of_file -> ()
    | bus_from -> match_city bus_from flag
  end

let rec match_month m =
  try
    if Inputvalidate.valid_month m then inputs.(2) <- m
    else begin
      print_endline "\nYou entered an invalid month, please try again:";
      print_string [] "> ";
      match read_line () with
      | exception End_of_file -> ()
      | m -> match_month m
    end
  with Failure _ -> (
    print_endline "\nYou entered an invalid month, please try again:";
    print_string [] "> ";
    match read_line () with
    | exception End_of_file -> ()
    | m -> match_month m)

let rec match_day m d =
  try
    if Inputvalidate.valid_day m d then inputs.(3) <- d
    else begin
      print_endline "\nYou entered an invalid day, please try again:";
      print_string [] "> ";
      match read_line () with
      | exception End_of_file -> ()
      | d -> match_day m d
    end
  with Failure _ -> (
    print_endline "\nYou entered an invalid day, please try again:";
    print_string [] "> ";
    match read_line () with
    | exception End_of_file -> ()
    | d -> match_day m d)

let rec match_year y =
  try
    if Inputvalidate.valid_year y then inputs.(4) <- y
    else begin
      print_endline "\nYou entered an invalid year, please try again:";
      print_string [] "> ";
      match read_line () with
      | exception End_of_file -> ()
      | y -> match_year y
    end
  with Failure _ -> (
    print_endline "\nYou entered an invalid year, please try again:";
    print_string [] "> ";
    match read_line () with
    | exception End_of_file -> ()
    | y -> match_year y)

let execute () =
  let data_dir_prefix = "data" ^ Filename.dir_sep in

  let cities = Yojson.Basic.from_file (data_dir_prefix ^ "cities.json") in
  (* Megabus Handler *)
  let megabus_origin =
    City.megabus_of_city inputs.(0) (City.from_json cities)
  in
  let megabus_destination =
    City.megabus_of_city inputs.(1) (City.from_json cities)
  in
  let megabus_query =
    Megabus.make_query
      (String.concat "-" [ inputs.(4); inputs.(2); inputs.(3) ])
      (string_of_int megabus_destination)
      (string_of_int megabus_origin)
  in
  let ourbus_origin = City.ourbus_of_city inputs.(0) (City.from_json cities) in
  let ourbus_destination =
    City.ourbus_of_city inputs.(1) (City.from_json cities)
  in
  let ourbus_query =
    Ourbus.make_query
      (String.concat "/" [ inputs.(2); inputs.(3); inputs.(4) ])
      ourbus_destination ourbus_origin
  in
  if megabus_origin = 0 || megabus_destination = 0 then ()
  else Megabus.run megabus_query;
  if ourbus_origin = "" || ourbus_destination = "" then ()
  else
    let _ = Ourbus.run_parser ourbus_query in
    ()

let compare_helper a b =
  let x = a |> List.rev in
  let y = b |> List.rev in
  match (x, y) with
  | [], [] -> 0
  | h1 :: t1, h2 :: t2 -> compare h1 h2
  | _ -> 0

let rec output_handler () =
  if Sys.file_exists (data_dir_prefix ^ "megabus.json") then
    Sys.remove (data_dir_prefix ^ "megabus.json");
  if Sys.file_exists (data_dir_prefix ^ "ourbus.json") then
    Sys.remove (data_dir_prefix ^ "ourbus.json");
  execute ();
  ANSITerminal.print_string [ ANSITerminal.cyan ]
    "Here are some potential bus routes sorted by price. Take a look!\n";
  print_endline "\torigin\t\tdestination\tdate\t\tdepart  arrive\tprice\tnotes";
  try
    let megabus = Yojson.Basic.from_file (data_dir_prefix ^ "megabus.json") in
    let megabus_info = Megabus.get_info (Megabus.from_json megabus) in
    print_endline "Megabus:";
    List.iter
      (fun x ->
        List.iter (printf "\t%s") x;
        printf "\n")
      (List.sort compare_helper megabus_info);
    try
      let ourbus = Yojson.Basic.from_file (data_dir_prefix ^ "ourbus.json") in
      let ourbus_info = Ourbus.get_info (Ourbus.from_json ourbus) in
      print_endline "Ourbus:";
      List.iter
        (fun x ->
          List.iter (printf "\t%s") x;
          printf "\n")
        (List.sort compare_helper ourbus_info)
    with _ -> print_endline "Ourbus Query Unsuccessful"
  with _ -> print_endline "Megabus Query Unsuccessful"

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
                  | year -> (
                      match_year year;

                      ANSITerminal.print_string [ ANSITerminal.cyan ]
                        "\nThis is what you inputted. Is this correct? \n";
                      print_info ();
                      ANSITerminal.print_string [ ANSITerminal.cyan ]
                        "\n\
                         YES, this is correct. Please make the query. \n\
                         NO, this is incorrect, please redo.\n";
                      print_string [] "> [Y/N] ";
                      match String.lowercase_ascii (read_line ()) with
                      | "y" | "yes" ->
                          print_string [] "\n";
                          output_handler ()
                      | "n" | "no" -> input_handler ()
                      | _ -> print_string [] "Invalid token")))))

(** [main ()] prompts for Expedia to start*)
let rec main () =
  ANSITerminal.print_string [ ANSITerminal.red ]
    "\n\
     Welcome to Expedia for buses!\n\
     The suggested cities to travel to and from are:\n\
     As this is a system in development, there is only a small support of \
     cities.\n\
     \t";

  ANSITerminal.print_string [ ANSITerminal.red ]
    (String.concat " " Inputvalidate.valid_cities ^ "\n");

  input_handler ();

  ANSITerminal.print_string [ ANSITerminal.green ]
    "\nDo you want to make a new query?\nType <restart>\n";
  print_string [] "> ";
  match read_line () with
  | exception End_of_file -> exit 0
  | s -> if s = "restart" then main () else exit 0

(* Execute the game engine. *)
let () = main ()