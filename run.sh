#!/bin/bash

# !! WARNING: DO NOT EDIT IN ANY WAY

# Make sure docker in installed (below)
# Uninstall all unofficial docker files
# for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
# Install docker
# sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# !! Make sure git is installed

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $SCRIPT_DIR/config.sh

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
  docker remove cloudfserver
  exit 1
}
trap terminate SIGINT

echo $pass | docker -S run -d --name cloudfserver --restart unless-stopped cloudflare/cloudflared:latest tunnel --no-autoupdate run --token $cloudflare_token_id

echo $git_repo

repo_name=$(basename "$git_repo" .git)

git clone $git_repo
cd $repo_name

python3 -m venv env
source env/bin/activate
pip install -r requirements.txt | pv -p -t -e -r -a -b > /dev/null
uvicorn main:app --host 0.0.0.0 --port 8000