#!/bin/bash

read -p 'Root domain (e.g. kurtcms.org without the www subdomain): ' domain
[ -z $domain ] && echo "Root domain cannot be empty" && exit 1

read -p 'Email address for registration and recovery with EFF: ' email
[ -z $email ] && echo "Email cannot be empty" && exit 1

# Generate a NGINX config with the given domain
[ ! -f ../nginx-conf/nginx.conf-sample ] \
    && echo "Sample NGINX config is not found" && exit 1
cat ../nginx-conf/nginx.conf-sample | \
    sed "s/ROOT_DOMAIN/$domain/" > ../nginx-conf/nginx.conf

if command -v docker-compose &> /dev/null; then
    docker-compose up -d
else
    echo "Docker Compose is not installed" && exit 1
fi

# Create a dummy TLS certificate and private key and 
# restart NGINX to load the dummy certificate
dirname = $(echo $(basename $(dirname $(pwd))) | sed "s/\.//")
path = /var/lib/docker/volumes/${dirname}_certbot/_data/live/$domain/
mkdir -p $path && openssl req -x509 -nodes -newkey rsa:4096 -days 1 \
    -keyout ${path}privkey.pem -out ${path}fullchain.pem -subj '/CN=localhost'
docker-compose restart nginx

# Remove the dummy certificate and private key before 
# requesting a signed TLS certificate with Certbot
# and restart NGINX to load the new certificate
rm -r $(dirname $path)
docker-compose run --rm --entrypoint "certbot certonly --webroot \
    --webroot-path=/var/www/html --email $email --agree-tos --eff-email \
    --force-renewal -d $domain -d www.$domain" certbot
docker-compose restart nginx

systemctl enable docker