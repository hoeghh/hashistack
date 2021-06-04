project = "traefik"

app "traefik-ha" {
  deploy {
    use "nomad-jobspec" {
      // Templated to perhaps bring in the artifact from a previous
      // build/registry, entrypoint env vars, etc.
      jobspec = templatefile("${path.app}/traefik.nomad")
    }
  }
}