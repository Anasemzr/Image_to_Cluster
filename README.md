🚀 Infrastructure as Code : Cluster K3d & Déploiement Automatisé

Ce projet démontre la mise en place d'une chaîne de déploiement moderne utilisant Packer pour la création d'images, Ansible pour l'automatisation, et K3d (Kubernetes léger) pour l'orchestration.
📋 Table des matières

    Architecture de la solution

    Prérequis

    Installation de l'environnement

    Processus de travail (Step-by-Step)

    Automatisation et Vérification

🏗 Architecture de la solution

L'objectif est de transformer un simple fichier index.html en un service haute disponibilité tournant dans un cluster Kubernetes local.

    Packer : Build une image Docker personnalisée basée sur Nginx.

    K3d : Héberge notre cluster Kubernetes (K3s) dans des conteneurs Docker.

    Ansible : Pilote kubectl pour déployer l'infrastructure de manière déclarative.

💻 Prérequis

Avant de lancer le projet, assurez-vous d'avoir :

    Docker installé et tournant.

    kubectl (L'outil de ligne de commande Kubernetes).

    Python 3 & pip (pour Ansible).

🛠 Installation de l'environnement
1. K3d (Kubernetes dans Docker)
Bash

curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=v5.6.0 bash

2. Packer (HashiCorp)
Bash

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install packer

3. Ansible
Bash

pip install ansible

⚙️ Processus de travail
Étape 1 : Création du Cluster

On crée un cluster avec un mapping de port pour accéder à nos services depuis l'extérieur (Port 8081).
Bash

k3d cluster create my-cluster -p "8081:80@loadbalancer"

Étape 2 : Build de l'image (Packer)

Packer utilise le fichier build.pkr.hcl. Il prend notre index.html local et l'injecte dans une image Nginx toute neuve.
Bash

packer init .
packer build build.pkr.hcl

Étape 3 : Importation de l'image

Kubernetes ne connaît pas vos images locales. Il faut "pousser" l'image dans le cluster :
Bash

k3d image import mon-nginx-custom:v1 -c my-cluster --overwrite

Étape 4 : Déploiement (Ansible)

Le Playbook deploy-k3d.yml automatise la création du Deployment et du Service.
Bash

ansible-playbook deploy-k3d.yml

🚀 Automatisation et Vérification
Script de lancement rapide

Pour tout lancer d'un coup, utilisez le script run.sh :
Bash

chmod +x run.sh
./run.sh

    Note Pédagogique : Le script inclut une commande kubectl wait. Cela permet d'attendre que le Pod soit réellement prêt (Statut: Running) avant de tenter d'ouvrir l'accès.

Comment vérifier que ça marche ?

    Vérifier les Pods : kubectl get pods (doit être Running).

    Accéder à l'application :

        Via le tunnel automatisé : http://localhost:8888

        Via l'entrée LoadBalancer (si configurée) : http://localhost:8081

🛠 Dépannage (FAQ)

    Erreur 404 ? Assurez-vous que le port-forward est actif ou qu'un Ingress est configuré.

    Pod en statut Pending ? K3d n'a peut-être plus de ressources ou l'image n'a pas été importée correctement avec k3d image import.

    Conflit de port 8080 ? Le cluster a été configuré sur le port 8081 pour éviter les conflits classiques.

Projet réalisé dans le cadre de la Séquence 1 : Maîtrise de l'écosystème Kubernetes local.
