#!/bin/bash

cat <<EOT >Makefile
PACKAGE_MANAGER = 'yarn'

.PHONY: default
default: build

.PHONY: build
build:
	if [ ! -d ./node_modules/ ]; then \$(PACKAGE_MANAGER) install; fi
	\$(PACKAGE_MANAGER) run build

.PHONY: clean
clean:
	rm build/ -rf

.PHONY: clean_node_modules 
clean_node_modules:
	rm node_modules/ -rf

.PHONY: deep_clean
deep_clean: clean clean_node_modules

.PHONY: run
run: 
	if [ ! -d ./node_modules/ ]; then \$(PACKAGE_MANAGER) install; fi
	\$(PACKAGE_MANAGER) run start
EOT

