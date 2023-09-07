# Signed in as root user
apt update && apt upgrade -y \
    && adduser azzazkhan
    && usermod -aG sudo azzazkhan
    && passwd -d azzazkhan
    && mkdir /home/azzazkhan/.ssh \
    && cp /root/.ssh/authorized_keys /home/azzazkhan/.ssh/authorized_keys
    && chown -R azzazkhan:root /home/azzazkhan/.ssh


# Signed in as local user
sudo apt-get --fix-broken install -y curl wget git zip unzip tar zsh \
    ca-certificates build-essential software-properties-common apache2 \
    apt-transport-https
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install PHP
sudo add-apt-repository ppa:ondrej/php -y \
    && sudo apt-get update \
    && sudo apt-get upgrade -y \
sudo apt-get --fix-missing install -y php8.1 php8.1-common php8.1-cli \
    php8.1-fpm php8.1-cgi libapache2-mod-php8.1 libapache2-mod-fcgid \
    php-phpseclib php8.1-bcmath php8.1-bz2 php8.1-curl php8.1-decimal \
    php8.1-dev php8.1-ds php8.1-fpm php8.1-grpc php8.1-imagick \
    php8.1-gmp php8.1-mbstring php8.1-mcrypt php8.1-mysql php8.1-opcache \
    php8.1-redis php8.1-sqlite3 php8.1-xdebug php8.1-xml php8.1-xmlrpc \
    php8.1-yaml php8.1-zip

# Enable required Apache modules and tell it to pass PHP script to FPM for
# processing
sudo a2enmod proxy_fcgi setenvif headers rewrite \
    && sudo a2enconf php8.1-fpm \
    && sudo systemctl reload apache2

# Install MariaDB (MySQL)
sudo apt-get install -y mariadb-server mariadb-client
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
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && sudo mv composer.phar /usr/local/bin/composer

# Install redis server and setup helper scripts
sudo apt install redis-server -y
wget https://raw.githubusercontent.com/azzazkhan/notes/master/commands/laraserve.sh -o ~/.laraserve \
    && wget https://raw.githubusercontent.com/azzazkhan/notes/master/commands/larastop.sh -o ~/.larastop \
    && chmod +x ~/.laraserve ~/.larastop \
    && echo "\n# Custom paths" >> ~/.zshrc \
    && echo "export PATH=\"\$PATH:\$(yarn global bin):/home/linuxbrew/.linuxbrew/bin\"" >> ~/.zshrc \
    && echo "\n# Custom general aliases" >> ~/.zshrc \
    && echo "alias zshconfig=\"vim ~/.zshrc\"" >> ~/.zshrc \
    && echo "alias commit=\"git commit -S -m \$1\"" >> ~/.zshrc \
    && echo "\n# Helper service management scripts" >> ~/.zshrc \
    && echo "alias laraserve=\"sh ~/.laraserve\"" >> ~/.zshrc \
    && echo "alias larastart=\"sh ~/.laraserve\"" >> ~/.zshrc \
    && echo "alias laraopen=\"sh ~/.laraserve\"" >> ~/.zshrc \
    && echo "alias laraclose=\"sh ~/.larastop\"" >> ~/.zshrc \
    && echo "alias larastop=\"sh ~/.larastop\"" >> ~/.zshrc \
    && echo "alias laraend=\"sh ~/.larastop\"" >> ~/.zshrc \
    && echo "\n# Laravel related helper aliases" >> ~/.zshrc \
    && echo "alias artisan=\"php artisan\"" >> ~/.zshrc \
    && echo "alias artisan-reset=\"artisan optimize:clear && artisan clear-compiled && artisan migrate:fresh --force\"" >> ~/.zshrc

# Install and setup Node.js
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
# Create DEB repository
NODE_MAJOR=18
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt-get update
sudo apt-get install nodejs -y

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
#! RSA 4096
gpg --full-generate-key \
    && gpg --list-secret-keys --keyid-format=long
KEY="B0D92B31F7EF73BD" gpg --armor --export $KEY \
    && git config --global user.signingkey $KEY

# Setup git
git config --global user.name "Azzaz Khan" && \
git config --global user.email "25636920+azzazkhan@users.noreply.github.com"
