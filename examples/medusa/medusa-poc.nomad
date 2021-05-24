job "medusa-import" {
  datacenters = ["dc1"]
  group "medusa" {
    count = 1
    task "medusa" {
      driver = "exec"
      config {
        command = "medusa"
        args    = ["--help"]
      }
      artifact {
        source      = "https://github.com/jonasvinther/medusa/releases/download/v0.2.2/medusa_0.2.2_linux_amd64.tar.gz"
        destination = "local"
        options {
          checksum = "sha256:c7299c0105a2aba90bd42349ad35fbc320da3b2de27a4e7ea6ec62278ae1b7e6"
        }
        mode        = "any"
      }
    }
  }
}
