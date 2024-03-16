#!/bin/bash

sh "./01-setup-user.sh"
sh "./02-system-and-shell-setup.sh"
sh "./03-apache-and-php-setup.sh"
sh "./04-setup-phpmyadmin.sh"
sh "./05-setup-mysql.sh"
sh "./06-setup-redis.sh"
sh "./07-setup-node.sh"
sh "./08-setup-shell-helpers.sh"
sh "./09-setup-python.sh"
sh "./10-setup-docker.sh"
sh "./11-setup-mongo-db.sh"
sh "./12-setup-gh-cli.sh"


# Generate 4096 bit RSA key with email set to as GitHub temp email
gpg --full-generate-key
gpg --list-secret-keys --keyid-format=long
gpg --armor --export $KEY
git config --global user.signingkey $KEY
git config --global init.defaultBranch master

# Setup git
git config --global user.name "$GIT_USER"
git config --global user.email "$GIT_EMAIL"
