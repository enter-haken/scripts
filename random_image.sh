#!/bin/bash
# https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
    -x)
      X="$2"
      shift 2 # shift to next parameter
      ;;
    -y)
      Y="$2"
      shift 2 # shift to next parameter
      ;;
    -f|--file)
      FILENAME="$2"
      shift 2 # shift to next parameter
      ;;
    -m|--mode)
      MODE="$2"
      shift 2 # shift to next parameter
      ;;
    -h|--help)
      HELP="HELP"
      shift 1 # shift to next parameter
      ;;
  esac
done
set -- "$POSITIONAL[@]"

if [ -z $(command -v convert) ]; then
  echo "command 'convert' (imagemagick) not found."
  exit 1
fi

if [ ! -z "$HELP" ]; then
  echo "-x for x resolution (default 1920)"
  echo "-y for y resolution (default 1920)"
  echo "-f|--file for output filename (default std out)"
  exit 0
fi

if [ -z "$X" ]; then
  X=3840
fi

if [ -z "$Y" ]; then
  Y=2160
fi

if [ -z "$MODE" ]; then
  MODE="points"
fi



if [ -z "$FILENAME" ]; then
  FILENAME="jpg:-"
fi

case "$MODE" in
  "points") head -c "$((3*X*Y))" /dev/urandom | convert -depth 8 -size "${X}x${Y}" RGB:- $FILENAME;;
  "swirl") convert -size  "${X}x${Y}" gradient: -swirl $(shuf -i 1-180 -n 1) $FILENAME;;
esac

#  http://www.imagemagick.org/Usage/canvas/
