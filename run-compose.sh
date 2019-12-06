#!/bin/sh
#
sudo KAFKA_SSL_SECRETS_DIR=${PWD}/dev/secrets docker-compose -f dev/docker-compose.yml up --build --abort-on-container-exit --force-recreate --remove-orphans
