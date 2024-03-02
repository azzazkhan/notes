#!/bin/bash

sudo apt-get --fix-broken install -y gnupg curl wget git zip unzip tar zsh \
    ca-certificates build-essential software-properties-common apt-transport-https

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
