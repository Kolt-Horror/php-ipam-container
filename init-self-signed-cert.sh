#!/bin/bash

# Generate a self-signed SSL certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /etc/ssl/private/apache-selfsigned.key \
-out /etc/ssl/certs/apache-selfsigned.crt \
-subj "/C=$SSL_COUNTRY/ST=$SSL_STATE/L=$SSL_LOCALITY/O=$SSL_ORGANIZATION/OU=$SSL_ORGANIZATIONAL_UNIT/CN=$SSL_COMMON_NAME"

# Update the default-ssl.conf file with the paths to the new certificate and key
sed -i 's|SSLCertificateFile.*|SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt|' /etc/apache2/sites-available/default-ssl.conf
sed -i 's|SSLCertificateKeyFile.*|SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key|' /etc/apache2/sites-available/default-ssl.conf

# Exit with status code 0 to indicate success
exit 0