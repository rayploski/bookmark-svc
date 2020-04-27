#Set up where to find the Consul Server.
export CONFIGSOURCE_CONSUL_HOST="localhost:8500"
export CONFIGSOURCE_CONSUL_PREFIX="bookmark-svc"
export CONFIGSOURCE_CONSUL_VALIDITY=30


consul kv put ${CONFIGSOURCE_CONSUL_PREFIX}/quarkus.datasource.url jdbc:postgresql://127.0.0.1:5432/bookmark-db
consul kv put ${CONFIGSOURCE_CONSUL_PREFIX}/quarkus.datasource.driver org.postgresql.Driver
consul kv put ${CONFIGSOURCE_CONSUL_PREFIX}/quarkus.datasource.username postgres
consul kv put ${CONFIGSOURCE_CONSUL_PREFIX}/quarkus.datasource.password docker
consul kv put ${CONFIGSOURCE_CONSUL_PREFIX}/quarkus.datasource.max-size 8
consul kv put ${CONFIGSOURCE_CONSUL_PREFIX}/quarkus.datasource.min-size 2
consul kv put ${CONFIGSOURCE_CONSUL_PREFIX}/quarkus.hibernate-orm.database.generation update
consul kv put ${CONFIGSOURCE_CONSUL_PREFIX}/quarkus.hibernate-orm.log.sql true
