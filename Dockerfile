# Use an official PHP image with Apache
FROM php:7.4-apache

# Define environment variables for MariaDB
ENV MARIADB_ROOT_PASSWORD=VMware1! \
    MARIADB_DATABASE=phpipam_db \
    MARIADB_USER=phpipam_user \
    MARIADB_PASSWORD=VMware1!

# Define environment variables for self-signed SSL certificate
ENV SSL_COUNTRY=AU \
    SSL_STATE=ACT \
    SSL_LOCALITY=Canberra \
    SSL_ORGANIZATION=VMware \
    SSL_ORGANIZATIONAL_UNIT=Testing \
    SSL_COMMON_NAME=testing-container.example.com

# Install additional dependencies, PHP extensions, and MariaDB Server
RUN apt-get update && apt-get install -y \
    mariadb-server \
    git \
    fping \
    libgmp-dev \
    libldap2-dev \
    libmcrypt-dev \
    libpng-dev \
    libfreetype6-dev \
    libjpeg-dev \
    && docker-php-ext-install pdo pdo_mysql sockets gmp ldap gettext \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd

# Allow Git to clone into directories within the container
RUN git config --global --add safe.directory /var/www/html

# Clone the latest version of PHP IPAM from GitHub
RUN git clone --recursive https://github.com/phpipam/phpipam.git /var/www/html \
    && cd /var/www/html \
    && git checkout -b 1.5 origin/1.5

# Copy the Docker-specific PHP IPAM configuration
RUN cp /var/www/html/config.docker.php /var/www/html/config.php

# Generate a self-signed SSL certificate using a shell script
COPY init-self-signed-cert.sh /usr/local/bin/init-self-signed-cert.sh
RUN chmod +x /usr/local/bin/init-self-signed-cert.sh \
    && /usr/local/bin/init-self-signed-cert.sh

# Configure Apache for PHP IPAM
COPY phpipam-apache.conf /etc/apache2/sites-available/000-default.conf

# Enable mod_rewrite for URL rewriting
RUN a2enmod rewrite

# Enable SSL module and the updated site configuration
RUN a2enmod ssl \
    && a2ensite default-ssl

# Remove .git files and non-prod directories, set file permissions
RUN find /var/www/html -name ".git*" -exec rm -fr {} \; 2>/dev/null || true \
    && find /var/www/html -type d \( -name "test" -o -name "tests" -o -name "examples" -o -name "demo*" \) -exec rm -fr {} \; 2>/dev/null || true \
    && find /var/www/html -type f -exec chmod u=rw,go=r {} \; \
    && find /var/www/html -type d -exec chmod u=rwx,go=rx {} \; \
    && find /var/www/html -type d -name upload -exec chmod a=rwx {} \; \
    && chmod a=rwX /var/www/html/css/images/logo

# Copy the custom initialization script
COPY init-database-script.sh /usr/local/bin/init-database-script.sh
RUN chmod +x /usr/local/bin/init-database-script.sh

# Expose web and SQL ports
EXPOSE 80 443 3306

# Set the custom script as the entry point
CMD ["init-database-script.sh"]