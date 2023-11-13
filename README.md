# PHP IPAM Docker Container

## Introduction
This repository contains Dockerfiles for creating a PHP IPAM Docker image. It is intended for running a non-production level PHP IPAM environment.

## Building the Docker Image
To build the Docker image, run the following command in the directory containing the Dockerfile:

```bash
docker build -t php-ipam-non-prod .
```

## Running the Container
After building the image, you can run the PHP IPAM container using:

```bash
docker run -d -p 80:80 -p 8443:443 --name ipam php-ipam-non-prod
```

## Environment Variables
The Docker image uses several environment variables for configuration.

### MariaDB Environment Variables
These variables are used for configuring the MariaDB database within the container.

```dockerfile
ENV MARIADB_ROOT_PASSWORD=VMware1!
    MARIADB_DATABASE=phpipam_db
    MARIADB_USER=phpipam_user
    MARIADB_PASSWORD=VMware1!
```

### SSL Certificate Environment Variables
These variables are for setting up a self-signed SSL certificate.

```dockerfile
ENV SSL_COUNTRY=AU
    SSL_STATE=ACT
    SSL_LOCALITY=Canberra
    SSL_ORGANIZATION=VMware
    SSL_ORGANIZATIONAL_UNIT=Testing
    SSL_COMMON_NAME=testing-container.example.com
```

## Notes
- Ensure that these environment variables align with your security and configuration standards, especially when adapting the container for different environments.
- The default settings are not intended for production use. Please modify the configurations accordingly for production deployment.

## Contributions
Contributions to this project are welcome. Please submit any issues or pull requests through GitHub.

---

For more information on PHP IPAM, visit [PHP IPAM's official website](https://phpipam.net/).
