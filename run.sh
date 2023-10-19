#!/bin/bash

# !! WARNING: DO NOT EDIT IN ANY WAY

# Make sure docker is installed (below)
# Uninstall all unofficial docker files
# for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
# Install docker
# sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# !! Make sure git is installed

# Check if the config.sh file exists
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source $SCRIPT_DIR/config.sh

git_repo=$1
runCmd=$2

eval "$pass"
eval "$cloudflare_token"

# Get the Cloudflare token ID
cloudflare_token_id=$(echo "$cloudflare_token" | cut -d '-' -f 6)

echo $pass | sudo -S echo ""
if [[ $? -ne 0 ]]; then
  echo "Error: Incorrect password."
  exit 1
fi

# Function to terminate both terminal processes
terminate() {
  echo "Ctrl+C pressed. Terminating the script and the terminal..."
  pkill -P $$
  exit 1
}
trap terminate SIGINT

gnome-terminal -- bash -c "echo $pass | sudo -S docker run cloudflare/cloudflared:latest tunnel --no-autoupdate run --token $cloudflare_token_id" &
terminal_pid=$!

echo $git_repo

repo_name=$(basename "$git_repo" .git)

git clone $git_repo
cd $repo_name

python3 -m venv env
source env/bin/activate
pip install -r requirements.txt | pv -p -t -e -r -a -b > /dev/null
uvicorn main:app --host 0.0.0.0 --port 8000