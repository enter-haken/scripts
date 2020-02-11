#!/usr/bin/env bash

echo "starting cloning at $(date --iso-8601=seconds)" > /tmp/clone_or_pull.log
cd ~/src/other/complete/

for user in $(ls -1); do
  ~/.local/bin/clone_or_pull -u $user &>> /tmp/clone_or_pull.log
done
echo "stoped cloning at $(date --iso-8601=seconds)" >> /tmp/clone_or_pull.log
