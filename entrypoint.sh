#!/bin/sh

# Start RabbitMQ server in the background
rabbitmq-server &

# Start Nginx in the foreground
nginx -g 'daemon off;'
