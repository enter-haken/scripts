#!/bin/bash

# https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
       -n|--name)
            NAME="$2"
            shift 2 # shift to next parameter
            ;;
       -h|--help)
            HELP="HELP"
            shift 1 # shift to next parameter
            ;;
     esac
done
set -- "$POSITIONAL[@]"

if [ ! -z "$HELP" ]; then
    echo "hakyll_init"
    echo "========="
    echo ""
    echo "This script generates a scaffold for creating a hakyll project."
    echo ""
    echo "If not yet happened install 'stack' with:"
    echo ""
    echo "  $ curl -sSL https://get.haskellstack.org/ | sh"
    echo ""
    echo "parameters:"
    echo "-n | --name: project name"
    echo ""
    echo "This script creates the following files:"
    echo ""
    echo "Makefile"
    echo "- everything about generating and showing the hakyll project"
    echo ""
    exit 0
fi

if [ -z "$NAME" ]; then
    echo "missing mandatory -n | --name"
    exit 1
fi

if [ ! -f ~/.local/bin/hakyll-init ]; then stack install hakyll; fi;
hakyll-init $NAME

echo ""
echo "a folder $NAME is created."
echo "change to folder $NAME and execute"
echo ""
echo "  $ make generate"
echo ""
echo "to generate the site."
echo ""
echo "Excecute"
echo ""
echo "  $ make watch"
echo ""
echo "to serve the site on http://localhost:8080"
echo ""

cat <<EOT > $NAME/Makefile
.PHONY: default
default: compile

.PHONY: help
help:
	@echo "make compile - compile the generator"
	@echo "make generate - generate the site and compile the generator if necessary"
	@echo "make watch - serves the site at http://localhost:8000 and generates the site if necessary"
	@echo "make clean - deletes the generated content"
	@echo "make remove_generator - removes the generator it self"
	@echo "make deep_clean - deletes the generated content and the generator it self"

.PHONY: compile 
compile:
	if [ ! -f stack.yaml ]; then stack init; fi
	stack build	

.PHONY: generate
generate:
	if [ ! -d ./.stack-work ]; then make compile; fi;
	stack exec site build

.PHONY: watch
watch:
	if [ ! -d _site ]; then make generate; fi;
	stack exec site watch

.PHONY: clean
clean:
	rm ./_site -rf || true
	rm ./_cache -rf || true

.PHONY: remove_generator
remove_generator:
	rm ./.stack-work -rf

.PHONY: deep_clean
deep_clean: clean remove_generator
EOT
