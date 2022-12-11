#!/bin/bash

# Python Setup
python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt

# OCaml Setup
opam update
opam upgrade
opam install -y tls mechaml core