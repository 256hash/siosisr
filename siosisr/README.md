🐳 Projet d'Installation et d'Exploitation Docker

Ici je propose une solution complète pour mettre en place rapidement un environnement de développement et de monitoring sur une machine virtuelle (VM) Linux.


**Script.sh**(a copier depuis mon git) c'est un outil d'installation qui installe Docker, ainsi que toutes les dépendances nécessaires, pour que la VM soit prête à l'emploi.
 Dans le Docker Compose j'ai mis Zabbix (supervision) et un Wordpress (page web)

 Utilisation et Exploitation du Projet
Étape 1 : Préparation de la VM

Le point de départ est l'exécution du script install_docker.sh.

    Copier le script sur votre VM.

    Le rendre exécutable :
    Bash

chmod +x install_docker.sh

Lancer l'installation (en étant root ou avec sudo) :
Bash

    ./install_docker.sh

    Ce script installe Docker et configure votre utilisateur pour pouvoir utiliser docker sans avoir besoin de taper sudo à chaque fois.

Étape 2 : Lancement des Applications 

Une fois Docker installé, vous devez utiliser le fichier docker-compose.yml que je vous mets a disposition

Pour lancer les deux applications en même temps (WordPress, Zabbix, et leurs bases de données associées), vous utilisez une seule commande :
Bash

docker compose up -d

Commande	Explication Simple
docker compose up	Lit le fichier de configuration et démarre tous les conteneurs définis.

-d	Détaché (Daemon) : Lance les conteneurs en arrière-plan pour que vous puissiez continuer à utiliser votre terminal.
Étape 3 : Accès aux Services (Mapping de Ports)

L'exploitation des services passe par la fonctionnalité de mapping de ports.

Comme les conteneurs ont leurs propres réseaux internes, nous devons "mapper" (lier) leurs ports de service internes vers des ports ouverts sur votre VM.
Service	Port Interne (Conteneur)	Port Externe (VM)

Exemple : Si vous choisissez le port 8081 pour WordPress et que l'IP de votre VM est 192.168.1.50, vous accédez au site via : http://192.168.1.50:8081.

🛑 Arrêt et Nettoyage

Pour arrêter et supprimer tous les conteneurs créés par Docker Compose, utilisez :

docker compose down
