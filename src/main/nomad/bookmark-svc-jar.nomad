job "bookmark-svc-job" {

  datacenters = ["bend"]

  # Run this job as a "service" type. Each job type (service, batch, system) has different
  # properties.
  # Synopsis:  https://www.nomadproject.io/docs/job-specification/job/#type
  # Additional info on types:  https://www.nomadproject.io/docs/schedulers/
  type = "service"

  # Allows to specify a rescheduling strategy. Nomad will then attempt to schedule the task on another
  # node if any of its allocation statuses become "failed".
  # https://www.nomadproject.io/docs/job-specification/job/#reschedule
  reschedule {
    delay = "30s"
    delay_function = "constant"
    unlimited = true
  }

  # A group defines a series of tasks that should be co-located on the same client (host). All tasks within a group
  # will be placed on the same host.
  # Details on the group stanza:  https://www.nomadproject.io/docs/job-specification/group/
  group "bookmark-svc-group" {

    # https://www.nomadproject.io/docs/job-specification/group/#count
    count = 1

    # Details on the restart stanza: https://www.nomadproject.io/docs/job-specification/restart/
    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    # Details on the task stanza:  https://www.nomadproject.io/docs/job-specification/task/
    task "bookmark-svc" {

      # Details on the Java driver:  https://www.nomadproject.io/docs/drivers/java/
      driver = "java"
      config {
        jar_path = "local/bookmark-svc.jar"
        jvm_options = "-Xmx2048m"
      }
    }

    # Specifying an artifact is required with the "java" driver. This is the
    # mechanism to ship the Jar to be run.
    artifact {
        source = "http://localhost/artifacts/bookmark-svc.jar"

#      options {
#        checksum = "md5:123445555555555"
#      }
    }
  }
}