# A nomad job for spinnning up the postgresql database.
# This job requires a client configuration that maps a storage path on the client identified as "bookmark".  An example
# configuration is in this same directory and named client.hcl.
# $ nomad run bookmark-db.nomad
#
job "bookmark-db" {
  datacenters = ["bend"]

  # Run this job as a "service" type. Each job type has different
  # properties.
  # https://www.nomadproject.io/docs/job-specification/job/#type
  type = "service"

  # Allows to specify a rescheduling strategy. Nomad will then attempt to schedule the task on another node if any of
  #its allocation statuses become "failed".
  # https://www.nomadproject.io/docs/job-specification/job/#reschedule
  reschedule {
    delay = "30s"
    delay_function = "constant"
    unlimited = true
  }
  # A group defines a series of tasks that should be co-located
  # on the same client (host). All tasks within a group will be
  # placed on the same host.
  # https://www.nomadproject.io/docs/job-specification/group/
  group "bookmark-db-group" {
    count = 1

    volume "bookmark-volume" {
      type      = "host"
      read_only = false
      # Defined in the client.hcl file.
      source    = "bookmark"
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    # Create an individual task (unit of work). This particular
    # task utilizes a Docker container to start a postgresql db.
    task "bookmark-db" {
      driver = "docker"

      config {
        image = "postgres:11"
        port_map {
          postgresql = 5432
        }
      }

      resources {
        cpu    = 500 #MHz
        memory = 512 #MB
        network {

          port "postgresql" {
            # Currently postgres is set up to dynamically assign a port.
            # Uncomment below if you prefer a static port.
            # static = 5432
          }
        }
      }

      service {
        port = "postgresql"
        tags = ["bookmark-svc", "db", "postgres", "container"]
        meta {
          meta = "postgresql backend for the bookmark service."
        }

        check {
          type = "tcp"
          port = "postgresql"
          interval = "20s"
          timeout = "5s"
        }

      }

      volume_mount {
        # mount to volume that is defined above
        volume      = "bookmark-volume"
        # what path in the container should be mapped
        destination = "/var/lib/postgresql/data"
        # DB needs to write.
        read_only   = false
      }

      # It is possible to set environment variables which will be
      # available to the task when it runs.
      env = {
        "POSTGRES_USER"     = "bookmark"
        "POSTGRES_PASSWORD" = "test"
        "POSTGRES_DB"       = "bookmark-db"
      }


    }
  }
}
