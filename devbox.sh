#!/usr/bin/env bash

if [ "$( docker container inspect -f '{{.State.Status}}' devbox)" != "running" ]; then
  make -C ~/.config/nvim/devbox/ 
else
  make -C ~/.config/nvim/devbox/ down
fi
