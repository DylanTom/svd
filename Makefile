build:
	dune build

code:
	-dune build
	code .
	! dune build --watch

utop:
	OCAMLRUNPARAM=b dune utop src

test:
	OCAMLRUNPARAM=b dune exec test/main.exe

play:
	OCAMLRUNPARAM=b dune exec bin/main.exe

check:
	@bash check.sh

finalcheck:
	@bash check.sh final

zip:
	rm -f svd.zip
	zip -r svd.zip . -x@exclude.lst

clean:
	dune clean
	rm -f svd.zip

loc:
	dune clean
	cloc --by-file --include-lang=OCaml .

locall:
	dune clean
  cloc .
