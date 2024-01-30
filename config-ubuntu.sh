#!/usr/bin/env bash

set -e 

dl_url="https://raw.githubusercontent.com/sergetensen/setmeup-scotty/main/"
dl_files=( authorized_keys tmux.conf 10_sshd_policy.conf )

mkdir ~/temp
chmod 700 ~/temp
cd ~/temp
for dl_file in "${dl_files[@]}"
do
#  curl "$dl_url$dl_file" -O
  echo "$dl_url$dl_file" -O
done
cd ..
rm -rf ~/temp
