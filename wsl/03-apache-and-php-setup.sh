#!/bin/bash

sudo apt-get install -y apache2
sudo systemctl enable apache2

# Install APT repositories for getting latest PHP version
sudo add-apt-repository ppa:ondrej/php -y \
    && sudo apt-get update \
    && sudo apt-get upgrade -y

sudo apt-get --fix-missing install -y libapache2-mod-php8.3 \
    libapache2-mod-fcgid php-phpseclib php8.3-bcmath php8.3-bz2 \
    php8.3-cgi php8.3-cli php8.3-common php8.3-curl php8.3-decimal php8.3-dev \
    php8.3-ds php8.3-fpm php8.3-gd php8.3-gmp php8.3-gnupg php8.3-grpc \
    php8.3-http php8.3-igbinary php8.3-imagick php8.3-inotify php8.3-intl \
    php8.3-ldap php8.3-mbstring php8.3-memcached php8.3-mongodb \
    php8.3-msgpack php8.3-mysql php8.3-opcache php8.3-pcov php8.3-pgsql \
    php8.3-phpdbg php8.3-protobuf php8.3-raphf php8.3-rdkafka php8.3-readline \
    php8.3-redis php8.3-sqlite3 php8.3-ssh2 php8.3-swoole php8.3-tidy \
    php8.3-uuid php8.3-vips php8.3-xdebug php8.3-xml php8.3-xmlrpc php8.3-xsl \
    php8.3-yaml php8.3-zip

sudo usermod -aG www-data $USER && sudo chown -R $USER:$USER /var/www

sudo a2enmod proxy_fcgi setenvif headers rewrite \
    && sudo a2enconf php8.3-fpm \
    && sudo systemctl reload apache2

sudo systemctl enable php8.3-fpm

curl -sLS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/bin/ --filename=composer
