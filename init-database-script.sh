#!/bin/bash

# Start MariaDB service
mysqld_safe &

# Wait for a few seconds to ensure MariaDB is up
sleep 5

# Set MariaDB root password
mysql -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${MARIADB_ROOT_PASSWORD}');"
mysql -e "FLUSH PRIVILEGES;"

# Start Apache in the foreground
exec apache2-foreground