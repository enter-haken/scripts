#!/bin/bash

# https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -a|--author)
            AUTHOR="$2"
            shift 2 # shift to next parameter
            ;;
        -t|--title)
            TITLE="$2"
            shift 2 # shift to next parameter
            ;;
        -f|--filename)
            FILENAME="$2"
            shift 2 # shift to next parameter
            ;;
        -v|--pdfviewer)
            PDFVIEWER="$2"
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
    echo "book_init"
    echo "========="
    echo ""
    echo "This script generates a scaffold for creating a book."
    echo ""
    echo "parameters:"
    echo "-a | --author: author of the book (mandatory)"
    echo "-t | --title: book title (mandatory)" 
    echo "-f | --filename: filename used for the pdf / tex file without any extension (mandatory)"
    echo "-v | --pdfviewer: pdf viewer used in makefile (default evince)" 
    echo ""
    echo "This script creates the following files:"
    echo ""
    echo "00-preamble.md"
    echo "- meta data for latex proces"
    echo "- first paragraph"
    echo ""
    echo "99-epilogue.md"
    echo "- last words"
    echo ""
    echo "Makefile"
    echo "- everything about generating and showing the book"
    exit 0
fi

if [ -z "$AUTHOR" ]; then
    echo "missing mandatory -a | --author"
    exit 1
fi

if [ -z "$TITLE" ]; then
    echo "missing mandatory -t | --title"
    exit 1
fi

if [ -z "$FILENAME" ]; then
    echo "missing mandatory -f | --filename"
    exit 1
fi

if [ -z "$PDFVIEWER" ]; then
    PDFVIEWER="evince"
fi

cat <<EOT >00-preamble.md
---
documentclass: book
title: $TITLE
author: $AUTHOR
---
# First words

Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.

EOT

cat <<EOT >99-epilogue.md
# Last word

Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.

EOT

cat <<EOT > Makefile
.PHONY: help clean compile latex run all
help:
	@echo "clean - delete temporary files"
	@echo "compile - generate the book with pandoc"
	@echo "latex - generate the latex source with pandoc"
	@echo "run - shows the book with $PDFVIEWER"
	@echo "all - target for: clean compile run"

compile:
	cat *.md > /tmp/book.md
	pandoc -s /tmp/book.md -o $FILENAME.pdf

run:
	if [ -f $FILENAME.pdf ]; then evince $FILENAME.pdf; fi

latex:
	cat *.md > /tmp/book.md
	pandoc -s /tmp/book.md -o $FILENAME.tex

clean:
	touch empty.pdf
	rm *.pdf
	touch /tmp/book.md
	rm /tmp/book.md
	touch book.tex
	rm book.tex

all: clean compile run
EOT
