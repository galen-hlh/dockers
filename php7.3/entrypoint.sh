#!/bin/bash

/etc/init.d/cron restart &
nginx
docker-php-entrypoint php-fpm