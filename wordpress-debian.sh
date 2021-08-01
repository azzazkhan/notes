# Install `unzip` and `wget` packages
sudo apt update
sudo apt install unzip
# Download and unzip the WordPress latest archive
cd ~
wget -P Downloads https://wordpress.org/latest.zip
cd Downloads
unzip latest.zip
# Move the contents of wordpress to apache web root
sudo mv -v /wordpress/* /var/www/html
# Delete the downloaded files and empty folders
rm -r wordpress & rm latest.zip

# Set apache http directory permissions
sudo chown -Rv www-data.www-data /var/www/html/