# Update the system
sudo apt-get update && sudo apt-get upgrade -y

# Install required packages
sudo apt-get install curl git wget zip tar zsh ca-certificates build-essential software-properties-common -y

# First thing first, install oh-my-zsh (zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install apache server and start the service
sudo apt-get install apache2 -y && sudo service apache2 start

# Install and setup PHP 8.1
sudo add-apt-repository ppa:ondrej/php -y

# Update the system to fetch packages from newly added repositories
sudo apt-get update && sudo apt-get upgrade -y

# Install PHP 8.1 along with apache-php compaitable modules
sudo apt-get install php8.1 php8.1-fpm libapache2-mod-php8.1 libapache2-mod-fcgid \
     php-phpseclib -y

# Enabled and set apache configurations for PHP 8.1
sudo a2enmod proxy_fcgi setenvif && sudo a2enconf php8.1-fpm

# Installing useful PHP extensions
sudo apt-get --fix-missing install php8.1-bcmath php8.1-bz2 php8.1-cgi php8.1-cli \
     php8.1-common php8.1-curl php8.1-dba php8.1-decimal php8.1-dev php8.1-ds \
     php8.1-fpm php8.1-gd php8.1-imagick php8.1-gmp php8.1-mbstring php8.1-mcrypt \
     php8.1-memcache php8.1-memcached php8.1-mongodb php8.1-mysql php8.1-opcache \
     php8.1-pgsql php8.1-psr php8.1-sqlite3 php8.1-ssh2 php8.1-vips php8.1-xdebug \
     php8.1-xml php8.1-xmlrpc php8.1-xsl php8.1-yaml php8.1-zip -y

# Restart PHP 8.1 and apache server to reflect changes
sudo service php8.1-fpm stop && sudo service php8.1-fpm start
sudo service apache2 stop && sudo service apache2 start

# Install MariaDB and start the service
sudo apt-get install mariadb-server mariadb-client -y
sudo service mysql start

# Run MySQL setup
sudo mysql_secure_installation
# Set root password? [Y] - Enter a strong root user password
# Remove anonymous user? [Y]
# Remove test database and access to it? [Y]
# Reload privilages tables now? [Y]

# Login to MySQL and root user and setup
sudo mysql -u root -p
# Creating two MySQL super users, one for phpMyAdmin and one for general use
# MariaDB [(none)]> CREATE USER 'pma'@'localhost' IDENTIFIED BY 'pmapass';
# MariaDB [(none)]> GRANT ALL PRIVILEGES ON *.* TO 'pma'@'localhost' WITH GRANT OPTION;
# MariaDB [(none)]> CREATE USER 'admin'@'localhost';
# MariaDB [(none)]> GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;
# MariaDB [(none)]> FLUSH PRIVILEGES;


# Download phpMyAdmin and setup all trust GPG keys
cd ~ && mkdir Downloads
wget -P Downloads https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
wget -P Downloads https://files.phpmyadmin.net/phpmyadmin.keyring
wget -P Downloads https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz.asc
gpg --import Downloads/phpmyadmin.keyring
gpg --verify Downloads/phpMyAdmin-latest-all-languages.tar.gz.asc

# Extract the phpMyAdmin files under `opt/phpmyadmin` directory
sudo mkdir /opt/phpmyadmin
sudo tar xvf Downloads/phpMyAdmin-latest-all-languages.tar.gz --strip-components=1 -C /opt/phpmyadmin

# Download the custom configuration file with pre-defined configurations for development environmant
wget -P Downloads https://raw.githubusercontent.com/azzazkhan/notes/master/stubs/phpmyadmin-config.inc.php
sudo mv ~/Downloads/phpmyadmin-config.inc.php /opt/phpmyadmin/config.inc.php

# Create a symbolic link for phpMyAdmin in apache directory
sudo ln -s /opt/phpmyadmin /var/www/html/phpmyadmin

# Set appropriate ownership of apache directory so VS Code don't give permission errors
sudo chown -R www-data:www-data /var/www/html/phpmyadmin
sudo chown -R $USER:$USER /var/www

# Restart the PHP 8.1 service and apache server
sudo service php8.1-fpm stop && sudo service php8.1-fpm start
sudo service apache2 stop && sudo service apache2 start

# Install and setup composer
cd ~/Downloads
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

# Install Redis in-memory database for caching
sudo apt install redis-server -y

# Setup custom scripts for starting and stopping all services
cd ~
wget https://raw.githubusercontent.com/azzazkhan/notes/master/commands/laraserve.sh -O .laraserve
wget https://raw.githubusercontent.com/azzazkhan/notes/master/commands/larastop.sh -O .larastop
chmod +x .laraserve .larastop
echo "alias laraserve=\"sh ~/.laraserve\"" >> ~/.zshrc
echo "alias larastart=\"sh ~/.laraserve\"" >> ~/.zshrc
echo "alias laraopen=\"sh ~/.laraserve\"" >> ~/.zshrc
echo "alias laraclose=\"sh ~/.larastop\"" >> ~/.zshrc
echo "alias larastop=\"sh ~/.larastop\"" >> ~/.zshrc
echo "alias laraend=\"sh ~/.larastop\"" >> ~/.zshrc

# Setup Git to use Windows Git credentials manager
git config --global user.name "Azzaz Khan"
git config --global user.email "25636920+azzazkhan@users.noreply.github.com"
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager-core.exe"
