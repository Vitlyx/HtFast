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
  sleep 5
  echo "Docker container removed. Exiting from script..."
  exit 1
}
trap terminate SIGINT

echo "Opening a Docker container..."
echo $pass | docker run -d --name cloudfserver cloudflare/cloudflared:latest tunnel --no-autoupdate run --token $cloudflare_token_id
sleep 10

echo $git_repo
repo_name=$(basename "$git_repo" .git)
git clone $git_repo
cd $repo_name


#⬇ Run Your Startup Code Bellow ⬇#
# Default Code #

#If wanted to use this default code...
# Download the `HtFast` repo and setup this program!
python3 -m venv env
source env/bin/activate
pip install -r requirements.txt | pv -p -t -e -r -a -b > /dev/null
uvicorn main:app --host 0.0.0.0 --port 8000