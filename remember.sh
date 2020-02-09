#!/bin/bash
POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
    -s|--search)
      SEARCH="$2"
      shift 2 # shift to next parameter
      ;;
  esac
done
set -- "$POSITIONAL[@]"

if [ ! -z "$SEARCH" ]; then
  brain --search $SEARCH | fdp -Tpng | feh -Z -
else
  brain --all | fdp -Tpng | feh -Z -
fi



