job "nats" {
  datacenters = ["dc1"]
  group "nats-server" {
    network {
      port "com" {
        static = 4222
      }
      port "cluster" {
        static = 6222
      }
      port "monitor" {
        static = 8222
      }
    }
    service {
      name = "nats-server"
      port = "com"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.http.rule=Path(`/nats`)",
      ]

      check {
        type     = "http"
        port     = "monitor"
        path     = "/varz"
        interval = "2s"
        timeout  = "2s"
      }
    }
    count = 1
    task "nats" {
      driver = "docker"
      config {
        image        = "nats:2.2.5-scratch"
        volumes = [
          "local/nats-server.conf:/nats-server.conf",
        ]
        ports = [
          "com",
          "cluster",
          "monitor",
        ]
      }
      resources {
        cpu    = 300
        memory = 256
      }
      template {
        data = <<EOF
port: 4222
http_port: 8222
cluster {
  port: 6222
  authorization {
    user: ruser
    password: T0pS3cr3t
    timeout: 2
  }
  routes = []
}       
EOF
        destination = "local/nats-server.conf"
      }
    }
  }
}
