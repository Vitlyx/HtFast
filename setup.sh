#!/bin/bash

# !! DO NOT EDIT THIS INSTALLATION SCRIPT

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pass=$(read -s -p "Enter your server's account password: ")
cloudflare_token=$(read -s -p "Enter your Cloudflare token (docker): ")

if [[ ! $(command -v docker) ]]; then
  echo "Docker is not installed."
  echo "Please install docker to proceed."
fi

echo $pass | sudo -s echo ""
if [[ $? -ne 0 ]]; then
  echo "Error: Incorrect password."
  exit 1
fi

echo "NOTICE: No information of yours will be shared, DO NOT edit any of the files (except for ones prompted to do so.)"
echo "Do you agree to the Cloudflare Terms of Service? (y/n)"
read -r cld_agreement
if [[ "$cld_agreement" != "y" ]]; then
  echo "Please look over Cloudflare's Terms and agree."
  exit 1
fi

echo $pass | sudo -s apt install pv -y
echo $pass | sudo -s apt install gnome-terminal -y | pv -p -t -e -r -a -b > /dev/null
echo $pass | sudo -s apt update -y | pv -p -t -e -r -a -b > /dev/null

# Change permissions of run.sh, config.sh, and uninstall.sh in the script's directory
echo $pass | sudo -s chmod +x "$SCRIPT_DIR/run.sh"
echo $pass | sudo -s chmod +x "$SCRIPT_DIR/config.sh"
echo $pass | sudo -s chmod +x "$SCRIPT_DIR/uninstall.sh"

# Use sudo to write to config.sh
echo "pass=$pass" | sudo tee "$SCRIPT_DIR/config.sh" > /dev/null
echo "cloudflare_token=$cloudflare_token" | sudo tee -a "$SCRIPT_DIR/config.sh" > /dev/null

echo "Setup Complete!"