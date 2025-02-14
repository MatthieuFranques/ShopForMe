# Utiliser une image de base avec Python et Arduino CLI
FROM python:3.10-slim

# Installer les dépendances système nécessaires
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Installer Arduino CLI
RUN curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh

# Ajouter Arduino CLI au PATH
ENV PATH="/root/.arduino15/bin:$PATH"

# Installer les bibliothèques Python nécessaires
RUN pip install pyserial

# Préparer le dossier de travail
WORKDIR /app
COPY . /app

# Rendre les scripts exécutables
RUN chmod +x /app/scripts/entrypoint.sh

# Installer les cartes ESP32 via Arduino CLI
RUN arduino-cli core update-index && \
    arduino-cli core install esp32:esp32

# Entrée par défaut pour le conteneur
ENTRYPOINT ["/app/scripts/entrypoint.sh"]
