#!/bin/sh

sleep 5

mkdir -p /data/logs/nginx/
chmod -Rf 777 /data/logs/nginx/

/confd/confd -backend etcdv3 -node http://host.docker.internal:2379 -watch &

sleep 5

nginx -g 'daemon off;'
