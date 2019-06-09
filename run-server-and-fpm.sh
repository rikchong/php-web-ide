#!/bin/bash

echo "Starting code-server..."
code-server --allow-http -e /opt > /dev/stdout 2>&1 &
echo "Starting PHP-FPM..."
docker-php-entrypoint php-fpm
