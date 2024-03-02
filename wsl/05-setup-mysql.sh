#!/bin/bash

sudo apt-get install -y mysql-server mysql-client
sudo systemctl start mysql
sudo systemctl enable mysql
sudo mysql_secure_installation
sudo mysql -u root -p

# MariaDB [(none)]> CREATE USER 'pma'@'localhost' IDENTIFIED BY 'pmapass';
# MariaDB [(none)]> GRANT ALL PRIVILEGES ON *.* TO 'pma'@'localhost' WITH GRANT OPTION;
# MariaDB [(none)]> CREATE USER 'admin'@'localhost';
# MariaDB [(none)]> GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;
# MariaDB [(none)]> FLUSH PRIVILEGES;
