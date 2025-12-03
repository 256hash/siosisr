#!/bin/bash

# ==========================================================
# SCRIPT D'INSTALLATION ET CONFIGURATION COMPLÈTE DE GIT SUR LINUX
# (Mode Root/Privilégié - Pas de 'sudo')
# ==========================================================

# --- 1. Définir les variables utilisateur ---
read -p "Entrez votre nom complet pour la configuration Git (ex: Jane Doe) : " GIT_NAME
read -p "Entrez votre email pour la configuration Git (utilisé sur GitHub) : " GIT_EMAIL

if [[ -z "$GIT_NAME" || -z "$GIT_EMAIL" ]]; then
    echo "❌ Erreur : Nom et/ou email ne peuvent être vides. Arrêt du script."
    exit 1
fi

echo "### Démarrage de l'installation et configuration de Git... ###"

# --- 2. Installation de Git ---
echo "1. Mise à jour des paquets et installation de Git..."
# Mettre à jour le système et installer git
apt-get update >/dev/null 2>&1
apt-get install -y git openssh-client >/dev/null 2>&1

if [ $? -ne 0 ]; then 
    echo "❌ Erreur critique : Échec de l'installation de Git ou OpenSSH. Veuillez vérifier votre connexion et les sources APT."
    exit 1
fi
echo "   -> Git installé avec succès."

# --- 3. Configuration Globale de Git ---
echo "2. Configuration globale de l'utilisateur Git..."
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global init.defaultBranch main
echo "   -> Configuration enregistrée : Nom='$GIT_NAME', Email='$GIT_EMAIL'."

# --- 4. Création et Configuration de la Clé SSH (pour GitHub) ---
echo "3. Génération de la clé SSH (Ed25519) pour l'authentification GitHub..."

SSH_KEY_FILE="$HOME/.ssh/id_ed25519"

# Créer le répertoire .ssh si non existant
mkdir -p "$HOME/.ssh"

# Générer la clé (si elle n'existe pas)
if [ ! -f "$SSH_KEY_FILE" ]; then
    # -t ed25519 (Algorithme moderne et sécurisé), -f (nom du fichier), -N (passphrase vide pour la simplicité)
    ssh-keygen -t ed25519 -f "$SSH_KEY_FILE" -N "" >/dev/null 2>&1
    echo "   -> Clé SSH générée."
else
    echo "   -> Clé SSH ($SSH_KEY_FILE) existante. Utilisation de celle-ci."
fi

# Démarrer l'agent SSH et ajouter la clé (pour gestion dans la session courante)
eval "$(ssh-agent -s)" >/dev/null
ssh-add "$SSH_KEY_FILE" 2>/dev/null

# --- 5. Affichage de la Clé Publique (Action Requise !) ---
echo "=========================================================="
echo "✅ Configuration Git et SSH terminée. Une action est requise !"
echo "----------------------------------------------------------"
echo "COPIEZ LA CLÉ PUBLIQUE CI-DESSOUS et AJOUTEZ-LA à votre compte GitHub :"
echo "   (Settings -> SSH and GPG keys -> New SSH key)"
echo "----------------------------------------------------------"
cat "${SSH_KEY_FILE}.pub"
echo "----------------------------------------------------------"
echo "Une fois la clé ajoutée sur GitHub, vous pourrez 'git push' sans mot de passe."
echo "=========================================================="
echo ""

# Test de connexion
echo "Test de connexion SSH à GitHub (après l'ajout de la clé sur le site) :"
ssh -T git@github.com
