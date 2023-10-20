#!/bin/bash

#  __      __  _____   _______   _       __     __
#  \ \    / / |_   _| |__   __| | |      \ \   / /
#   \ \  / /    | |      | |    | |       \ \_/ / 
#    \ \/ /     | |      | |    | |        \   /  
#     \  /     _| |_     | |    | |____     | |   
#      \/     |_____|    |_|    |______|    |_|                                                   

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $SCRIPT_DIR/config.sh

git_repo=$1

# eval "$pass"
# eval "$cloudflare_token"

cloudflare_token_id=$(echo "$cloudflare_token" | cut -d '-' -f 6)

echo $pass | sudo -s echo ""
if [[ $? -ne 0 ]]; then
  echo "Error: Incorrect password."
  exit 1
fi

terminate() {
  echo "Ctrl+C pressed. Terminating the script and the terminal..."
  docker kill cloudfserver
  sleep 2.5
  docker remove cloudfserver
  sleep 5
  echo "Docker container removed. Exiting from script..."
  exit 1
}
trap terminate SIGINT

echo "Opening a Docker container..."
echo $pass | docker run -d --name cloudfserver cloudflare/cloudflared:latest tunnel --no-autoupdate run --token $cloudflare_token_id
sleep 10

if [[ "$git_repo" == "HtFast" ]]; then
  echo "Starting 'HtFast.'"
  cd $SCRIPT_DIR/Htfast
else
  repo_name=$(basename "$git_repo" .git)
  git clone $git_repo
  cd $repo_name
fi


#⬇ Run Your Startup Code Bellow ⬇#
# Default Code #

# `HtFast` is automatically integrated. (default)
echo $pass | sudo python3 -S -m venv env
echo $pass | sudo source -S env/bin/activate
pip install -r requirements.txt | pv -p -t -e -r -a -b > /dev/null
uvicorn main:app --host 0.0.0.0 --port 8000