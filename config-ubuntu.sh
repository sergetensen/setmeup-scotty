#!/usr/bin/env bash

set -e 

dl_url="https://raw.githubusercontent.com/sergetensen/setmeup-scotty/main/files"
dl_files=( authorized_keys tmux.conf 10_sshd_policy.conf )

if [ ! -d ~/temp ]; then
  mkdir ~/temp
  chmod 700 ~/temp
  remove_temp="yes"
fi

cd ~/temp

for dl_file in "${dl_files[@]}"
do
  echo "$dl_url$dl_file" -O
  curl "$dl_url$dl_file" -O
done

if [[ "$remove_temp" == yes ]]; then
  #cd ..
  #rm -rf ~/temp
  echo "~/temp" should be removed."
fi
