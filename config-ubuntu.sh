#!/usr/bin/env bash

set -e 

dl_url="https://raw.githubusercontent.com/sergetensen/setmeup-scotty/main/files/"
dl_files=( authorized_keys tmux.conf 10_sshd_policy.conf )
0file_md5="d41d8cd98f00b204e9800998ecf8427e"

if [ ! -d ~/temp ]; then
  mkdir ~/temp && remove_temp="yes"
  chmod 700 ~/temp
fi

cd ~/temp

# Download the files
for dl_file in "${dl_files[@]}"
do
  echo "$dl_url$dl_file"
  curl "$dl_url$dl_file" -O
done

# Update the authorized_keys file
# If the file does not exist create (copy) it.

#If the files exists but is empty (the default) then add the keys.

authorized_keys_md5=$(md5sum ~/.ssh/authorized_keys | gawk '{ print $1 }')
if [[ $authorized_keys_md5 == $0file_md5 ]]; then
  echo "~/.ssh/authorized_keys exists but is empty. Your keys will be added."
  cat ~/temp/authorized_keys >> ~/.ssh/authorized_keys
fi

if [[ "$remove_temp" == yes ]]; then
  #cd ..
  #rm -rf ~/temp
  echo "~/temp should be removed."
fi
