#!/usr/bin/env bash

cat <<EOT >Makefile
.PHONY: default
default: compile

.PHONY: compile
compile:
	if [ ! -d deps ]; then mix deps.get; fi
	mix compile

.PHONY: run
run:
	if [ ! -d _build ]; then make; fi
	iex -S mix run 

.PHONY: clean
clean: 
	rm _build/ -rf
	rm deps/ -rf
EOT

