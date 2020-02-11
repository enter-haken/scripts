#!/usr/bin/env bash

sudo /etc/init.d/docker stop
sudo rm /var/lib/docker/ -rf
sudo /etc/init.d/docker start
