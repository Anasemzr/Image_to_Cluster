build {
  sources = ["source.docker.nginx"]

  # On copie ton fichier local vers un dossier temporaire dans le conteneur
  provisioner "file" {
    source      = "index.html"
    destination = "/tmp/index.html"
  }

  # On déplace le fichier vers le dossier public de Nginx
  provisioner "shell" {
    inline = ["mv /tmp/index.html /usr/share/nginx/html/index.html"]
  }

  post-processor "docker-tag" {
    repository = "mon-nginx-custom"
    tag        = ["v1"]
  }
}
