.PHONY: test check

build:
	dune build

test:
	OCAMLRUNPARAM=b dune exec test/main.exe

play:
	OCAMLRUNPARAM=b dune exec bin/main.exe

check:
	@bash check.sh

finalcheck:
	@bash check.sh final

zip:
	dune clean
	zip -r svd.zip . -x@exclude.lst

clean: bisect-clean
	dune clean
	rm -f svd.zip

loc:
	dune clean
	cloc --by-file --include-lang=OCaml .

locall:
	dune clean
	cloc .

doc:
	dune build @doc

opendoc: doc
	@bash opendoc.sh
	
bisect: bisect-clean
	-dune exec --instrument-with bisect_ppx --force test/main.exe
	bisect-ppx-report html

bisect-clean: 
	rm -rf _coverage bisect*.coverage

install:
	@bash setup.sh

