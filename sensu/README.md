# Sensu Dojo Plan

## Description

This plan runs both Sensu server and Sensu client based on a dojo config flag.

Sensu-plugin is also included in the vendored gems.

## Server Usage

* Start RabbitMQ `docker run -it --rm -e DOJ_RABBITMQ="rabbitmq = { default_user='sensu', default_pass='sensu', default_vhost='/sensu'}" karate/rabbitmq`
* Start Redis `docker run -it --rm -e DOJ_REDIS="protected-mode='no'" karate/redis --peer 172.17.0.3`
* Start Sensu server `docker run -it --rm -e DOJ_SENSU="log_level='debug'" karate/sensu --peer 172.17.0.3 --bind rabbitmq:rabbitmq.default --bind redis:redis.default`

## Client Usage

* Start RabbitMQ `docker run -it --rm -e DOJ_RABBITMQ="rabbitmq = { default_user='sensu', default_pass='sensu', default_vhost='/sensu'}" karate/rabbitmq`
* Start Sensu client `docker run -it --rm -e DOJ_SENSU="mode='client'" karate/sensu --peer 172.17.0.3 --bind rabbitmq:rabbitmq.default --bind redis:redis.default`

## Docker-compose environment

* docker-compose up
