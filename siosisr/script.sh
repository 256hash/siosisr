#!/bin/bash


set -e
set -x


update && apt upgrade -y

apt install -y ca-certificates curl gnupg

install -m 0755 -d /etc/apt/keyrings

# Téléchargement de la clé et conversion en format compatible
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Ajustement des droits sur la clé
chmod a+r /etc/apt/keyrings/docker.gpg

# Détection automatique de l'architecture et du nom de code (bookworm)
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update

#ajout plugin et conteneur
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl start docker
systemctl enable docker

# Permet de lancer docker sans 'sudo'
usermod -aG docker $USER

docker --version
docker compose version

echo "--- Installation terminée ! ---"
