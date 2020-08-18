#!/usr/bin/env bash
if [ ! -z "$1" ]; then
  brain --search $1 | fdp -Tpng | feh -Z -
else
  brain --all | fdp -Tpng | feh -Z -
fi
