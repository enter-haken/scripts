#!/usr/bin/env bash
for image in $(curl https://picsum.photos/v2/list | jq '.[] | .download_url' -r);
do
  wget -O $(uuidgen).jpg $image;
done
