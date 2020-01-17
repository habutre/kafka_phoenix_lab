#!/bin/sh
#
export KAFKA_SSL_SECRETS_DIR=${PWD}/dev/secrets
SSL_CONFIG_FILE=${PWD}/dev/ssl.config
SSL_OUTPUT_FILE=/tmp/ssl.config

echo -e "$KAFKA_SSL_SECRETS_DIR"
sed -e "s#@@SECRETS_PATH@@#$KAFKA_SSL_SECRETS_DIR#g" $SSL_CONFIG_FILE > $SSL_OUTPUT_FILE

echo -e "Stopping Cluster if running"
docker-compose -f dev/docker-compose.yml down

echo -e "Stopping and removing pre-existent containers"

for i in `sudo docker ps -qa`; do sudo docker stop $i && sudo docker rm $i; done

echo -e "Removing pre-existent and not used volumes"
for i in `sudo docker volume ls -f dangling=true`; do sudo docker volume rm $i; done

echo -e "Starting the Kafka Cluster"
#sudo KAFKA_SSL_SECRETS_DIR=${PWD}/dev/secrets docker-compose -f dev/docker-compose.yml up --build --abort-on-container-exit --force-recreate --remove-orphans
docker-compose -f dev/docker-compose.yml up -d --build --force-recreate --remove-orphans

echo -e "Waiting 1 min to finishing the bootstraping so that we can create the expected topics"
sleep 60

echo -e "Is up and running?"
docker-compose -f ${PWD}/dev/docker-compose.yml logs --tail 25

echo -e "Hope the cluster be up and running"
kafka-topics.sh --bootstrap-server "localhost:19092,localhost:29092,localhost:39092" --command-config $SSL_OUTPUT_FILE --create --replication-factor 3 --partitions 1 --topic attacks
kafka-topics.sh --bootstrap-server "localhost:19092,localhost:29092,localhost:39092" --command-config $SSL_OUTPUT_FILE --create --replication-factor 3 --partitions 1 --topic interactions

echo -e "All tasks finished"
