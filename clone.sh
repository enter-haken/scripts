#!/bin/bash
# https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
    -u|--user)
      USER="$2"
      shift 2 # shift to next parameter
      ;;
    -h|--help)
      HELP="HELP"
      shift 1 # shift to next parameter
      ;;
  esac
done
set -- "$POSITIONAL[@]"

if [ -z $(command -v jq) ]; then
  echo "command 'jq' not found."
  exit 1
fi


if [ -z $USER ]; then
  echo "the github user name -u|--user is mandatory for the request"
  exit 1
fi

if [ ! -z "$HELP" ]; then
  echo "-u|--user github user name"
  exit 0
fi

if [ ! -d $USER ]; then
  mkdir $USER
fi

cd $USER

for i in $(curl https://api.github.com/users/$USER/repos | jq '.[] | .html_url' -r); do
  git clone $i;
done

