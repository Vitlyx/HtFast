#!/bin/bash

# !! DO NOT EDIT THIS INSTALLATION SCRIPT

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

read -s -p "Enter your server's account password: " pass
echo ""
read -s -p "Enter your Cloudflare token (docker): " cloudflare_token
echo ""

if [[ ! $(command -v docker) ]]; then
  echo "Docker is not installed."
  echo "Please install docker to proceed."
fi

echo $pass | sudo -S echo ""
if [[ $? -ne 0 ]]; then
  echo "Error: Incorrect password."
  exit 1
fi

echo "NOTICE: No information of yours will be shared, DO NOT edit any of the files (except for ones prompted to do so)."
echo "Do you agree to the Cloudflare Terms of Service? (y/n)"
read -r cld_agreement
if [[ "$cld_agreement" != "y" ]]; then
  echo "Please look over Cloudflare's Terms and agree."
  exit 1
fi

echo $pass | sudo -S apt install pv -y
echo $pass | sudo -S apt update -y | pv -p -t -e -r -a -b > /dev/null
echo $pass | sudo -S apt install python3 -y | pv -p -t -e -r -a -b > /dev/null
echo $pass | sudo -S apt install python3-full | pv -p -t -e -r -a -b > /dev/null
echo $pass | sudo -S apt install python3-xyz | pv -p -t -e -r -a -b > /dev/null
echo $pass | sudo -S apt install pipx | pv -p -t -e -r -a -b > /dev/null
echo $pass | sudo -S apt install gnome-terminal -y | pv -p -t -e -r -a -b > /dev/null

echo $pass | sudo -S chmod +x "$SCRIPT_DIR/run.sh"
echo $pass | sudo -S chmod +x "$SCRIPT_DIR/config.sh"
echo $pass | sudo -S mkdir -p ~/.cache/pip
echo $pass | sudo -S chmod -R u+w ~/.cache/pip

echo "pass=\"$pass\"" | sudo tee "$SCRIPT_DIR/config.sh" > /dev/null
echo "cloudflare_token=\"$cloudflare_token\"" | sudo tee -a "$SCRIPT_DIR/config.sh" > /dev/null

echo "Setup Complete!"