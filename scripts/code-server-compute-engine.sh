#!/bin/bash

# Create new Compute Optimized VM (4 Cores + 16 GB RAM + 100 GB SSD) and Ubuntu 20.04 LTS OS in "asia-south1-a" zone (Mumbai)
gcloud compute instances create coder --project={$_PROJECT} --zone=asia-south1-a
    --machine-type=c2-standard-8 \
    --network-interface=network-tier=PREMIUM,subnet=default \
    --maintenance-policy=MIGRATE \
    --service-account={$_SERVICE_ACCOUNT_ID}-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,
             https://www.googleapis.com/auth/logging.write,
             https://www.googleapis.com/auth/monitoring.write,
             https://www.googleapis.com/auth/servicecontrol,
             https://www.googleapis.com/auth/service.management.readonly,
             https://www.googleapis.com/auth/trace.append \
    --tags=allow-3000,allow-4000,allow-5000,allow-8000,allow-8080,http-server \
    --create-disk=auto-delete=yes,
                  boot=yes,
                  device-name=coder,
                  image=projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20220308,
                  mode=rw,
                  size=100,
                  type=projects/{$_PROJECT}/zones/asia-south1-a/diskTypes/pd-ssd \
    --shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --reservation-affinity=any




# Enable ingress traffic to port 3000
gcloud compute --project={$_PROJECT} \
    firewall-rules create allow-3000 \
        --description="Allow ports for React, Next.js and other apps that use port 3000" \
        --direction=INGRESS \
        --priority=1000 \
        --network=default \
        --action=ALLOW \
        --rules=tcp:3000 \
        --source-ranges=0.0.0.0/0 \
        --target-tags=allow-3000,allow-react,allow-next-js,allow-node

# Enable ingress traffic to port 4000
gcloud compute --project={$_PROJECT} \
    firewall-rules create allow-4000 \
        --description="Allow ports for Vue, Nuxt.js and other apps that use port 4000" \
        --direction=INGRESS \
        --priority=1000 \
        --network=default \
        --action=ALLOW \
        --rules=tcp:4000 \
        --source-ranges=0.0.0.0/0 \
        --target-tags=allow-4000,allow-vue,allow-nuxt-js,allow-node

# Enable ingress traffic to port 5000
gcloud compute --project={$_PROJECT} \
    firewall-rules create allow-5000 \
        --description="Allow ports for GraphQL and other apps that use port 5000" \
        --direction=INGRESS \
        --priority=1000 \
        --network=default \
        --action=ALLOW \
        --rules=tcp:5000 \
        --source-ranges=0.0.0.0/0 \
        --target-tags=allow-5000,allow-graphql

# Enable ingress traffic to port 8000
gcloud compute --project={$_PROJECT} \
    firewall-rules create allow-8000 \
        --description="Allow ports for Laravel, node APIs and other apps that use port 8000" \
        --direction=INGRESS \
        --priority=1000 \
        --network=default \
        --action=ALLOW \
        --rules=tcp:8000 \
        --source-ranges=0.0.0.0/0 \
        --target-tags=allow-8000,allow-larave,allow-node

# Enable ingress traffic to port 8080
gcloud compute --project={$_PROJECT} \
    firewall-rules create allow-8080 \
        --description="Allow ports for code server and other apps that use port 8080" \
        --direction=INGRESS \
        --priority=1000 \
        --network=default \
        --action=ALLOW \
        --rules=tcp:8080 \
        --source-ranges=0.0.0.0/0 \
        --target-tags=allow-8080,allow-code-server




# Update system and install required dependencies
sudo apt update && sudo apt upgrade -y
sudo apt --fix-broken install curl wget zsh zip unzip tar git ca-certificates build-essential software-properties-common -y

# Download the code-server and extract into global scope
mkdir ~/Downloads
wget https://github.com/coder/code-server/releases/download/v{$_VERSION}/code-server-{$_VERSION}-linux-amd64.tar.gz -P ~/Downloads
tar -xzvf code-server-{$_VERSION}-linux-x86_64.tar.gz
sudo cp -r code-server-{$_VERSION}-linux-x86_64 /usr/lib/code-server

# Make globally accessible binary
sudo ln -s /usr/lib/code-server/code-server /usr/bin/code-server

# Directory for storing user's data
sudo mkdir /var/lib/code-server

# Initializing new service so the app could run in background
sudo vi /lib/systemd/system/code-server.service

################################################################################################################
# CONTENTS TO BE ADDED TO FILE (code-server.service)
################################################################################################################
# [Unit]
# Description=code-server
# After=nginx.service
# 
# [Service]
# Type=simple
# Environment=PASSWORD=$_PASSWORD
# ExecStart=/usr/bin/code-server --bind-addr 0.0.0.0:8080 --user-data-dir /var/lib/code-server --auth password
# Restart=always
# 
# [Install]
# WantedBy=multi-user.target
################################################################################################################

# Reload the daemon to load new service
sudo systemctl daemon-reload

# Start the created service and register it to load on init
sudo systemctl start code-server
sudo systemctl status code-server
sudo systemctl enable code-server



# Install Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
nvm install --lts
nvm use --lts
npm i -g yarn
yarn global add serve firebase-tools sass @nest/cli @angular/cli
