# Update the system
sudo apt-get update && sudo apt-get upgrade -y

# Install and setup node.js using NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
nvm install --lts
npm i -g yarn

# Setup yarn global bin folder and install general-use packages using yarn
echo "export PATH=\"\$PATH:\$(yarn global bin)\"" >> ~/.zshrc
yarn global add serve firebase-tools @angular/cli @nestjs/cli expo-cli eslint sass typescript