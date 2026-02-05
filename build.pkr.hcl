packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "nginx" {
  image  = "nginx:latest"
  commit = true
}

build {
  sources = ["source.docker.nginx"]

  provisioner "file" {
    source      = "index.html"
    destination = "/tmp/index.html"
  }

  provisioner "shell" {
    inline = ["mv /tmp/index.html /usr/share/nginx/html/index.html"]
  }

  post-processor "docker-tag" {
    repository = "mon-nginx-custom"
    tag        = ["v1"]
  }
}
