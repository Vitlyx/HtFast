#!/bin/bash
pass=$1
cloudflare_token=$2

echo $pass | sudo -s echo ""
if [[ $? -ne 0 ]]; then
  echo "Error: Incorrect password."
  exit 1
fi

if [[ ! "$cloudflare_token" =~ ^docker\ run\ cloudflare/cloudflared:latest\ tunnel\ --no-autoupdate\ run\ --token ]]; then
  echo "Error: Invalid Cloudflare token."
  exit 1
fi

echo $pass | sudo -s chmod +x run.sh
echo $pass | sudo -s chmod +x config.sh

echo "pass=$pass" >> config.sh
echo "cloudflare_token=$cloudflare_token" >> config.sh