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

  provisioner "shell" {
    inline = ["echo '<h1>Hello via Packer et K3d</h1>' > /usr/share/nginx/html/index.html"]
  }

  post-processor "docker-tag" {
    repository = "mon-nginx-custom"
    tag        = ["v1"]
  }
}
