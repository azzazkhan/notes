# Signed in as root user
apt update && apt upgrade -y \
    && adduser ubuntu
    && usermod -aG sudo ubuntu
    && passwd -d ubuntu
    && mkdir /home/ubuntu/.ssh \
    && cp /root/.ssh/authorized_keys /home/ubuntu/.ssh/authorized_keys
    && chown -R ubuntu:root /home/ubuntu/.ssh


# Signed in as local user
sudo apt-get --fix-broken install -y curl wget git zip unzip tar zsh \
    ca-certificates build-essential software-properties-common apache2 \
    apt-transport-https
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install PHP
sudo add-apt-repository ppa:ondrej/php -y \
    && sudo apt-get update \
    && sudo apt-get upgrade -y \
sudo apt-get --fix-missing install -y libapache2-mod-php8.3 \
    libapache2-mod-fcgid php-phpseclib php8.3-bcmath php8.3-bz2 php8.3-cgi \
    php8.3-cli php8.3-common php8.3-curl php8.3-decimal php8.3-dev php8.3-ds \
    php8.3-fpm php8.3-gd php8.3-gmp php8.3-gnupg php8.3-grpc php8.3-http \
    php8.3-igbinary php8.3-imagick php8.3-inotify php8.3-intl php8.3-mbstring \
    php8.3-mysql php8.3-opcache php8.3-pcov php8.3-pgsql php8.3-phpdbg \
    php8.3-protobuf php8.3-raphf php8.3-rdkafka php8.3-readline php8.3-redis \
    php8.3-sqlite3 php8.3-ssh2 php8.3-swoole php8.3-tidy php8.3-uuid php8.3-vips \
    php8.3-xdebug php8.3-xml php8.3-xmlrpc php8.3-xsl php8.3-yac php8.3-yaml \
    php8.3-zip

# Add user to www-group to prevent permission errors
sudo usermod -aG www-data ubuntu

# Enable required Apache modules and tell it to pass PHP script to FPM for
# processing
sudo a2enmod proxy_fcgi setenvif headers rewrite \
    && sudo a2enconf php8.3-fpm \
    && sudo systemctl reload apache2

# Install MySQL database server
sudo apt-get install -y mysql-server mysql-client
sudo systemctl start mysql
sudo mysql_secure_installation
sudo mysql -u root -p
# MariaDB [(none)]> CREATE USER 'pma'@'localhost' IDENTIFIED BY 'pmapass';
# MariaDB [(none)]> GRANT ALL PRIVILEGES ON *.* TO 'pma'@'localhost' WITH GRANT OPTION;
# MariaDB [(none)]> CREATE USER 'admin'@'localhost';
# MariaDB [(none)]> GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;
# MariaDB [(none)]> FLUSH PRIVILEGES;

# Install and setup PhpMyAdmin
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz \
    && sudo mkdir /opt/phpmyadmin \
    && sudo tar xvf phpMyAdmin-latest-all-languages.tar.gz --strip-components=1 -C /opt/phpmyadmin \
    && sudo wget https://raw.githubusercontent.com/azzazkhan/notes/master/stubs/phpmyadmin-config.inc.php -O /opt/phpmyadmin/config.inc.php \
    && sudo mkdir /opt/phpmyadmin/tmp \
    && sudo chown -R $USER:www-data /opt/phpmyadmin \
    && sudo chown -R www-data:www-data /opt/phpmyadmin/tmp \
    && sudo chown -R $USER:www-data /var/www \
    && ln -s /opt/phpmyadmin /var/www/html/phpmyadmin \
    && rm -f phpMyAdmin-latest-all-languages.tar.gz

# Install composer
curl -sLS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/bin/ --filename=composer

# Install Redis cache server
sudo apt install redis-server -y

# Install NVM
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
nvm install --lts && nvm use --lts
npm i -g yarn

# Setup custom shell exports and alises
echo "\n\n"  >> ~/.zshrc \
    && echo "export PATH=\"\$PATH:\$(yarn global bin):\$(composer global config bin-dir --absolute --quiet)\"\n" >> ~/.zshrc \
    && echo "alias artisan=\"php artisan\"\n" \
    && echo "alias mfs=\"php artisan migrate:fresh --seed\"\n" \
    && echo "alias artc=\"php artisan optimize:clear && php artisan clear-compiled\""

# Install and setup Node.js
# sudo apt-get update
# sudo apt-get install -y ca-certificates curl gnupg
# sudo mkdir -p /etc/apt/keyrings
# curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
# # Create DEB repository
# NODE_MAJOR=18
# echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
# sudo apt-get update
# sudo apt-get install nodejs -y

# Install Python3
sudo apt install -y libssl-dev libffi-dev python3 python3-dev \
    python-is-python3 python3-venv python3-pip

# Install and setup Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-cache policy docker-ce \
    && sudo apt install -y docker-ce \
    && sudo systemctl enable docker \
    && sudo usermod -aG docker ${USER} \
    && sudo apt-get install -y docker-compose-plugin

# Install and setup MongoDB
curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add - \
    && echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list \
    && sudo apt update \
    && sudo apt install -y mongodb-org \
    && sudo systemctl enable mongod \
    && sudo systemctl start mongod \
    && mongo --eval 'db.runCommand({ connectionStatus: 1 })'

# Install and setup GitHub CLI
type -p curl >/dev/null || sudo apt install curl -y \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y

# GPG key and commit signature verification
# Generate 4096 bit RSA key with email set to as GitHub temp email
gpg --full-generate-key
gpg --list-secret-keys --keyid-format=long
gpg --armor --export $KEY
git config --global user.signingkey $KEY

# Setup git
git config --global user.name ""
git config --global user.email ""
