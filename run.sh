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

eval "$pass"
eval "$cloudflare_token"
cloudflare_token_id=$(echo "$cloudflare_token" | cut -d '-' -f 6)

# Assign the gnome-terminal to a different terminal
export CLF_TERMINAL=xterm

echo $pass | sudo -s echo ""
if [[ $? -ne 0 ]]; then
  echo "Error: Incorrect password."
  exit 1
fi

terminate() {
  echo "Ctrl+C pressed. Terminating the script and the terminal..."
  kill "$terminal_pid"
  kill "$uvicorn_pid"
  exit 1
}
trap terminate SIGINT

# Start the Cloudflare tunnel
$CLF_TERMINAL -- bash -c "echo $pass | sudo -S docker run cloudflare/cloudflared:latest tunnel --no-autoupdate run --token $cloudflare_token_id" &
terminal_pid=$!

# Clone the Git repository
git clone $git_repo

# Change to the cloned directory
cd $(basename "$git_repo" .git)

# Create a virtual environment and install the requirements
python3 -m venv env
source env/bin/activate
pip install -r requirements.txt | pv -p -t -e -r -a -b > /dev/null

# Start the Uvicorn server
uvicorn main:app --host 0.0.0.0 --port 8000 &
uvicorn_pid=$!

# Wait for the user to press `Ctrl+C`
wait "$terminal_pid" "$uvicorn_pid"