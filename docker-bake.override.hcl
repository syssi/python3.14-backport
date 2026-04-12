target "github_output" {
  contexts = {
    native = "target:native"
  }
  dockerfile-inline = <<-EOT
  FROM debian:trixie-slim AS github_output
  COPY --from=native /github_outpu[t] /github_output
  EOT
  inherits = ["native"]
  output = ["type=docker"]
  tags = ["github_output"]
  target = "github_output"
}
