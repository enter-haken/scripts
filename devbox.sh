#!/usr/bin/env bash

if [ "$1" == "down" ]; then
  echo "stoping devbox container";
  if [ ! "$(docker ps -q -f name=devbox)" ] || [ "$(docker container inspect -f '{{.State.Status}}' devbox)" == "running" ]; then
    make -C ~/.config/nvim/devbox/ down 
  fi;
  exit 0;
fi;

if [ ! "$(docker ps -q -f name=devbox)" ] || [ "$( docker container inspect -f '{{.State.Status}}' devbox)" != "running" ]; then
  make -C ~/.config/nvim/devbox/ build
fi;

make -C ~/.config/nvim/devbox/ exec
