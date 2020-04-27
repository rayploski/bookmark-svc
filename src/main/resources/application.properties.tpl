# Properties file template for use with HashiCorp Consul to dynamically update database configuration.
# To use:  cd to this directory then consul-template -log-level  debug -template "application.properties.tpl:application.properties"
quarkus.datasource.url=jdbc:postgresql://{{ range service "bookmark-db" }}{{ .Address }}{{ end }}:5432/postgres
quarkus.datasource.driver=org.postgresql.Driver
quarkus.datasource.username=postgres
quarkus.datasource.password=docker
quarkus.datasource.max-size=8
quarkus.datasource.min-size=2
quarkus.hibernate-orm.database.generation=update
quarkus.hibernate-orm.log.sql=true
