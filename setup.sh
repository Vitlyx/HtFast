#!/bin/bash
pass=$1
cloudflare_token=$2

# Check if the password is correct
echo $pass | sudo -s echo ""
if [[ $? -ne 0 ]]; then
  echo "Error: Incorrect password."
  exit 1
fi

# Check if the Cloudflare token starts with the expected prefix
if [[ ! "$cloudflare_token" =~ ^docker\ run\ cloudflare/cloudflared:latest\ tunnel\ --no-autoupdate\ run\ --token ]]; then
  echo "Error: Invalid Cloudflare token."
  exit 1
fi

# Save the password and the Docker token into config.sh
echo "pass=$pass" >> config.sh
echo "cloudflare_token=$cloudflare_token" >> config.sh

# Make the run.sh script executable
echo $pass | sudo -s chmod +x run.sh
echo $pass | sudo -s chmod +x config.sh