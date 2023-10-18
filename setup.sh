#!/bin/bash

# !! WARNING: DO NOT EDIT IN ANY WAY

pass=$1
cloudflare_token=$2

if [[ ! $(command -v docker) ]]; then
  echo "Docker is not installed."
  echo "Please install docker to proceed."
fi

echo $pass | sudo -s echo ""
if [[ $? -ne 0 ]]; then
  echo "Error: Incorrect password."
  exit 1
fi

if [[ ! "$cloudflare_token" =~ "docker run cloudflare/cloudflared:latest tunnel" ]]; then
  echo "Error: Invalid Cloudflare token."
  exit 1
fi

echo "Do you agree to the Cloudflare Terms of Service? (y/n)"
read -r cld_agreement
if [[ "$cld_agreement" != "y" ]]; then
  echo "Please look over Cloudflare's Terms and agree."
  exit 1
fi
echo "NOTICE: \n No information of yours will be shared \n DO NOT edit any of the files (except for config.sh). (y/n)"
read -r rules_agreement
if [[ "$rules_agreement" != "y" ]]; then
  echo "This is a requirement, you have to accept to show your understandment."
  exit 1
fi

echo $pass | sudo -s apt-get install gnome-terminal pv | pv -p -t -e -r -a -b > /dev/null
echo $pass | sudo -s apt update | pv -p -t -e -r -a -b > /dev/null

echo $pass | sudo -s chmod +x run.sh
echo $pass | sudo -s chmod +x config.sh
echo $pass | sudo -s chmod +x uninstall.sh

echo "pass=$pass" > config.sh
echo "cloudflare_token=$cloudflare_token" >> config.sh