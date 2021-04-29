job "consul" {
  datacenters = ["dc1"]
  
  group "consul" {
    count = 1
    task "consul" {
      driver = "raw_exec"
            
      config {
        command = "consul"
        args    = ["agent", "-dev", "-ui"]
      }
      artifact {
        source = "https://releases.hashicorp.com/consul/1.6.2/consul_1.6.2_linux_amd64.zip"
      }
      resources {
        network {
          mbits = 10
          port "http" {
            to = 8500
          }
        }
      }
      service {
        name = "consul"
        port = "http"
        tags = [
          "urlprefix-/consul",
        ]
        check {
          name     = "alive"
          type     = "http"
          path     = "/ui/"
          interval = "10s"
          timeout  = "2s"
        }
      }

    }
  }
}