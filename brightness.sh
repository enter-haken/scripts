#!/usr/bin/env bash
# https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
    -v|--value)
      BRIGHTNESS="$2"
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
  echo "brightness"
  exit 0
fi

if [ -z "$BRIGHTNESS" ]; then
  BRIGHTNESS=6000
fi

echo $BRIGHTNESS > /sys/class/backlight/intel_backlight/brightness
