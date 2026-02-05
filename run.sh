#!/bin/bash

echo "--- 1. Build de l'image avec Packer (Copy de index.html) ---"
packer init build.pkr.hcl
packer build build.pkr.hcl

echo "--- 2. Import de l'image dans K3d ---"
k3d image import mon-nginx-custom:v1 -c my-cluster

echo "--- 3. Déploiement via Ansible ---"
ansible-playbook deploy-k3d.yml

echo "--- 4. Attente du démarrage du Pod ---"
kubectl wait --for=condition=Ready pod -l app=nginx-custom --timeout=60s

echo "--- 4. Activation de l'accès sur le port 8888 ---"
echo "L'accès sera disponible sur http://localhost:8888"
kubectl port-forward svc/nginx-custom 8888:80
