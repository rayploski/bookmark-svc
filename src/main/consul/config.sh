#!/usr/bin/env bash

#Set up where to find the Consul Server.
export CONFIGSOURCE_CONSUL_HOST="localhost:8500"
export CONFIGSOURCE_CONSUL_PREFIX="bookmark-svc"
export CONFIGSOURCE_CONSUL_VALIDITY=30

#Query Consul for the Nomad job running the postgresql database for the IP address and port
service_address=`curl http://${CONFIGSOURCE_CONSUL_HOST}/v1/catalog/service/bookmark-db-job-bookmark-svc-bookmark-db-task | jq -r .[].ServiceAddress`
service_port=`curl http://${CONFIGSOURCE_CONSUL_HOST}/v1/catalog/service/bookmark-db-job-bookmark-svc-bookmark-db-task | jq .[].ServicePort`

echo database address is $service_address:$service_port

#Put configuration for the microservice into Consul's Key/Value store
consul kv put ${CONFIGSOURCE_CONSUL_PREFIX}/quarkus.datasource.url jdbc:postgresql://$service_address:$service_port/bookmark-db
consul kv put ${CONFIGSOURCE_CONSUL_PREFIX}/quarkus.datasource.driver org.postgresql.Driver
consul kv put ${CONFIGSOURCE_CONSUL_PREFIX}/quarkus.datasource.username postgres
consul kv put ${CONFIGSOURCE_CONSUL_PREFIX}/quarkus.datasource.password docker
consul kv put ${CONFIGSOURCE_CONSUL_PREFIX}/quarkus.datasource.max-size 8
consul kv put ${CONFIGSOURCE_CONSUL_PREFIX}/quarkus.datasource.min-size 2
consul kv put ${CONFIGSOURCE_CONSUL_PREFIX}/quarkus.hibernate-orm.database.generation update
consul kv put ${CONFIGSOURCE_CONSUL_PREFIX}/quarkus.hibernate-orm.log.sql true
