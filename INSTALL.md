# Installation Instructions

Unless stated otherwise, execute all commands in the root directory of the project folder `svd`.

## Automatic Setup
```
make install
```

## Run
```
make build
make play
``` 

## Manual Setup
If you do not have OCaml installed, follow this guide

https://cs3110.github.io/textbook/chapters/preface/install.html

Once you have installed the CS 3110 OCaml OPAM switch, you will need to install the following packages by executing:
```
opam update
opam upgrade
opam install -y mechaml tls core core_unix
```

Additional Package Description:
+ [mechaml](https://github.com/yannham/mechaml): Mechaml is a functional web scraping library. It is built on top of existing libraries that provide low-level features : `Cohttp` and `Lwt` for asynchronous I/O and HTTP handling, and `Lambdasoup` to parse HTML.
+ [tls](https://github.com/mirleft/ocaml-tls): Transport Layer Security (TLS) is one of the most widely deployed security protocols on the Internet. This package implements TLS protocol purely in OCaml.
+ [core](https://opensource.janestreet.com/core/): Core is a souped-up and filled-out version of Base, Jane Street’s minimal standard library replacement. Some Core modules are extensions of their counterparts in Base.

**Important**

To add support for querying, we need to install a few python pacakages 
```
python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt
```

## Test (optional)
We would like to verify that every function is working as intended. To run our test suite, execute
```
make build
make test
```
Verify that there are no errors and the output response is `Ok`.


