#!/bin/bash

for user in $(ls -1); 
do 
  cat $user/repo_desc* | sed -e 's/^/'"$user"'\//'; 
done
