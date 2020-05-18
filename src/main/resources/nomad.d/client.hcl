# An example nomad client config
client {
  enabled = true
  # bookmark specifies the path on the client available to nomad jobs.
  host_volume "bookmark" {
    path = "/mnt/external2/storage/postgres/bookmark"
    read_only = false
  }
}

consul {

}