sudo apt update
sudo apt install wget -y
# Install Apache
sudo apt install apache2 -y
# Check the status of Apache service
systemctl status apache2

# Install PHP on Debian 10
sudo apt install php php-cgi php-mysqli php-pear php-mbstring php-gettext libapache2-mod-php php-common php-phpseclib php-mysql -y
# Verify the PHP version
php --version

# Install MariaDB on Debian 10
sudo apt install mariadb-server mariadb-client -y
#Check the status of MariaDB service
systemctl status mariadb
# Run wizard for securly configuring MariaDB
sudo mysql_secure_installation
# Set root password? [Y] - Enter a strong root user password
# Remove anonymous user? [Y]
# Remove test database and access to it? [Y]
# Reload privilages tables now? [Y]

# Create a new MariaDB user
sudo mysql -u root -p
# MariaDB [(none)]> CREATE DATABASE `wordpress`;
# MariaDB [(none)]> CREATE USER 'wordpress'@localhost IDENTIFIED BY 'wp-mariadb-debian';
#### Grant permissions to access and use the MySQL server from localhost only
# MariaDB [(none)]> GRANT USAGE ON *.* TO 'wordpress'@localhost IDENTIFIED BY 'wp-mariadb-debian';
#### To grant permission from any other computer on the network (unsecure)
# MariaDB [(none)]> GRANT USAGE ON *.* TO 'wordpress'@'%' IDENTIFIED BY 'wp-mariadb-debian';
#### Grant all privileges on a specific database
# MariaDB [(none)]> GRANT ALL privileges ON `wordpress`.* TO 'wordpress'@localhost;
# MariaDB [(none)]> FLUSH PRIVILEGES;
# MariaDB [(none)]> SHOW GRANTS FOR 'wordpress'@localhost;

# Download and verify phpMyAdmin
# Make sure you're in your own home directory
cd ~
wget -P Downloads https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
# Check phpMyAdmin GPG Keys
wget -P Downloads https://files.phpmyadmin.net/phpmyadmin.keyring
gpg --import Downloads/phpmyadmin.keyring
wget -P Downloads https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz.asc
gpg --verify Downloads/phpMyAdmin-latest-all-languages.tar.gz.asc

# Unpack and configure phpMyAdmin
sudo mkdir /var/www/html/phpmyadmin
sudo tar xvf Downloads/phpMyAdmin-latest-all-languages.tar.gz --strip-components=1 -C /var/www/html/phpmyadmin
# Copy and rename and edit sample configuration file
sudo cp /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php
# https://phpsolved.com/phpmyadmin-blowfish-secret-generator/
# $cfg['blowfish_secret'] = '';
# $cfg['blowfish_secret'] = '.MMPn3F:r/sl}gMGR]F0K1va{U]1}4:T';
sudo vi /var/www/html/phpmyadmin/config.inc.php
# Change permissions for `config.inc.php` file
sudo chmod 660 /var/www/html/phpmyadmin/config.inc.php
# Change ownership of `phpmyadmin` directory
sudo chown -R www-data:www-data /var/www/html/phpmyadmin
# Restart the apache server
sudo systemctl restart apache2

# Open localhost/phpmyadmin
