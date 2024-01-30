#!/usr/bin/env bash

dl_url="https://raw.githubusercontent.com/sergetensen/setmeup-scotty/main/"
dl_files=( authorized_keys tmux.conf 10_sshd_policy.conf )

function check_dl_files() {
  # $1
  # $2
}

mkdir ~/temp
chmod 700 ~/temp
cd ~/temp
curl "$dl_url${dl_files[1]}" -O  

# Update ~/.ssh/authorized_keys
