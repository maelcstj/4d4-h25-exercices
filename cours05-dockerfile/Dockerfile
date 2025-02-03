# Exemple de fichier Dockerfile

# Débuter d'image de base
FROM ubuntu:22.04

# Installer des programmes
# RUN apt update
# RUN apt install netcat-openbsd
# RUN apt clean

# Meillure pratique pour éviter layers inutiles
RUN apt update \ 
    && apt install -y netcat-openbsd \
    && apt -y clean

# Créer des variables d'environnement
ENV MY_VAR_1=12345
ENV MY_VAR_2="ma valeur de variable"

# Changer de dossier (cd)
WORKDIR /etc

RUN echo "mon fichier" > etcfile
RUN echo "mon fichier 2" > etcfile2

WORKDIR /home/ubuntu

# Copier des fichiers locaux
# Chemins locaux sont à partir du Dockerfile
COPY ./localfile ./localfile-copied

# Copier des URL
# ADD google.com  ./google-com-html

# Ouvrir un port interne
EXPOSE 8080

# Volume, ne pas l'utiliser, ne permet pas d'écraser dans Docker Compose
# VOLUME /etc

# Commande qui est lancée quand conteneur est lancé
CMD [ "echo", "Hello world!" ]
# ENTRYPOINT [ script.sh ]