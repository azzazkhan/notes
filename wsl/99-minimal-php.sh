sudo add-apt-repository ppa:ondrej/php -y \
    && sudo apt-get update \
    && sudo apt-get upgrade -y

sudo apt-get --fix-missing install -y \
    php8.3-bcmath \
    php8.3-common \
    php8.3-curl \
    php8.3-decimal \
    php8.3-dev \
    php8.3-ds \
    php8.3-mysql \
    php8.3-mbstring \
    php8.3-opcache \
    php8.3-readline \
    php8.3-sqlite3 \
    php8.3-xml
