#!/bin/bash
# Ensure we fail fast if there is a problem.
set -eo pipefail

# Move the files over to current directory
mv /root/composer.phar .
mv /root/composer.lock .
mv /root/vendor .

# Ensure that php is working
php -v

# Ensure that mysql server is up and running
ping -c 3 mysql

# Update packages
apt-get update -y

# Update project dependencies.
php composer.phar update

# Copy over testing configuration. This configuration is used for Gitlab CI unit testing
cp -v .env.gitlab-testing .env

# Generate an application key. Clear config and cache route
php artisan key:generate
php artisan optimize
php artisan config:clear
php artisan route:cache

# Run database migrations and seed the data
php artisan migrate --seed