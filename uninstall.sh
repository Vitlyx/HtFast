#!/bin/bash

# !! WARNING: DO NOT EDIT IN ANY WAY

source config.sh
eval "$pass"
echo "Are you sure you would like to uninstall this program? (y/n)"
read -r un_agreement
if [[ "$un_agreement" != "y" ]]; then
  exit 1
fi
current_dir=$(pwd)
echo $pass | sudo -s rm -r "$current_dir" -y | pv -p -t -e -r -a -b > /dev/null
echo "Deleted successfully."
