#!/bin/bash

/etc/init.d/cron restart &
docker-php-entrypoint php-fpm