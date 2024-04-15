#!/bin/bash

wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz \
    && sudo mkdir -p /opt/phpmyadmin \
    && sudo chown -R $USER:www-data /opt/phpmyadmin \
    && tar xvf phpMyAdmin-latest-all-languages.tar.gz --strip-components=1 -C /opt/phpmyadmin \
    && wget https://raw.githubusercontent.com/azzazkhan/notes/master/stubs/phpmyadmin-config.inc.php -O /opt/phpmyadmin/config.inc.php \
    && mkdir /opt/phpmyadmin/tmp \
    && sudo chown -R $USER:www-data /opt/phpmyadmin \
    && sudo chown -R www-data:www-data /opt/phpmyadmin/tmp \
    && ln -s /opt/phpmyadmin /var/www/html/phpmyadmin \
    && rm -f phpMyAdmin-latest-all-languages.tar.gz
