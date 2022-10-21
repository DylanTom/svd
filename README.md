# svd (Final Name TBD)
Get the best deals on buses back home!

---

## Instructions
1. Clone this repository or unzip `svd.zip`
2. Follow instructions in `INSTALL.md`

## About the Project
(Last Updated 10/21/22) Our current vision for the system we’re building is a terminal-based application that scrapes data from websites providing bus services such as MegaBus and OurBus and outputs all available routes based on user input. This application will also have filtering features based on start date, end date, time, location, price, and relevancy. The application will eventually have some form of automatic ranking system to rank all available bus routes for the user based on the parameters entered. 

---

## Acknowledgement 
Developers
+ [Sydney Ho](https://github.com/sydney-ho), sh967
+ [Vanessa Fang](https://github.com/vanessafang3), vf72
+ [Dylan Tom](https://github.com/DylanTom), dt425

Project Admin: 
+ Manager: Anirudh Sharma, as2844
+ Grader: Amanda Andreasen, apa49

Course Instructors:
+ Professor Michael Clarkson
+ Instructor Ryan Doenges

---

## Appendix
### Makefile Commands
1. `make build` : Builds the code in `src/`
2. `make test` : Runs the OUnit test suite in `test/`
3. `make play` : Launches the UI
4. `make check` : Verifies OCaml enviornment works
5. `make finalcheck`: Prepares the source code for submission
6. `make zip` : Creates a zip file to submit
7. `make clean` : Cleans all compiled files
8. `make loc` : Counts the lines of code in the root directory by file and in OCaml. You may need to install [cloc](https://github.com/AlDanial/cloc). Follow the installation instructions here.
9. `make locall` : Counts the lines of code in the root directory by language. You may need to install [cloc](https://github.com/AlDanial/cloc). Follow the installation instructions here.
10. `make doc` : Builds HTML documentation with ODoc
11. `make opendoc` : Opens a file browser window to the directory containing the documentation