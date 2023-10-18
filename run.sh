#!/bin/bash

# !! WARNING: DO NOT EDIT IN ANY WAY

# Make sure docker in installed (bellow)
# Uninstall all unofficial docker files
# for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
# Install docker
# sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# !! Make sure git is installed

source config.sh

git_repo=$1
runCmd=$2

eval "$pass"
eval "$cloudflare_token"

# Get the Cloudflare token ID
cloudflare_token_id=$(echo "$cloudflare_token" | cut -d '-' -f 6)

echo $pass | sudo -s echo ""
if [[ $? -ne 0 ]]; then
  echo "Error: Incorrect password."
  exit 1
fi

terminate() {
  echo "Ctrl+C pressed. Terminating the script and the terminal..."
  kill "$terminal_pid"
  exit 1
}
trap terminate SIGINT

gnome-terminal -- bash -c "echo $pass | sudo -S docker run cloudflare/cloudflared:latest tunnel --no-autoupdate run --token $cloudflare_token_id" &
terminal_pid=$!

git clone $git_repo | pv -p -t -e -r -a -b > /dev/null
cd $git_repo
python3 -m venv env
source env/bin/activate
pip install -r requirements.txt | pv -p -t -e -r -a -b > /dev/null
$runCmd