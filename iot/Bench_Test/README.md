# README: Script d'Upload Automatique pour ESP32

## Description

Ce script Python automatise la compilation et le téléversement de fichiers Arduino (".ino") vers les cartes ESP32 connectées au pc. Il identifie les cartes en fonction de leur numéro de série, compile le code associé à chaque carte, puis téléverse automatiquement le firmware.

---

## Fonctionnalités

1. **Identification automatique des cartes connectées** : Le script détecte les cartes ESP32 disponibles via les ports COM.
2. **Association des scripts** : Chaque carte est associée à un fichier ou dossier de script via un fichier `config.json`.
3. **Compilation automatique** : Le script compile les fichiers Arduino (".ino") avec `arduino-cli`.
4. \*\*Téléversement avec \*\***`esptool`** : Le firmware compilé est téléversé sur la carte ESP32.
5. **Rapport final** : À la fin de l'exécution, un rapport indique le succès ou l'échec de chaque étape pour chaque carte.

---

## Prérequis

### Outils requis

1. **Python** : Python 3.6 ou plus récent installé.
2. **arduino-cli** : Utilisé pour compiler les fichiers `.ino`.
   - Installation :
     exe sur https://arduino.github.io/arduino-cli/1.1/installation/

3. **esptool** : Pour téléverser le firmware sur l'ESP32.
   - Installation :
     pip install esptool

4. **Bibliothèques Python** : Installez les bibliothèques requises.
   - Installation :
     pip install pyserial


---

### Configuration requise

1. Fichier `config.json` : Ce fichier doit contenir les associations entre les numéros de série des cartes ESP32 et les chemins des scripts Arduino :
   ```json
   {
        "02CE820C": "app/tag/main/",
        "02CE81D3": "app/anchor1/main/",
        "02CE81D5": "app/anchor2/main/",
        "02CE6FBA": "app/anchor3/main/"
   }
   ```

   - La clé correspond au numéro de série de la carte.
   - La valeur est le chemin relatif du script Arduino.
2. **Organisation des fichiers** :
   - Le script Python (ex. `upload_script.py`) doit être placé dans `Bench_Test`.
   - Les fichiers Arduino doivent être dans `iot/app/`.

---

## Utilisation

### Étapes pour exécuter le script

1. Connectez vos cartes ESP32 à votre machine.
2. Placez les scripts `.ino` dans les dossiers associés définis dans `config.json`.
3. Exécutez le script :
   py upload_script.py
4. Observez les logs pour chaque carte : succès ou erreurs de compilation/téléversement.
5. Consultez le rapport final affiché à la fin de l'exécution.

---

## Structure des dossiers

iot/
|
├── Bench_Test/
|   ├── config.json
│   ├── upload_script.py
│   └── build/
|
└── app/
    ├── main/
    │   └── main.ino
    ├── tag1/
    │   └── main.ino
    ├── tag2/
    │   └── main.ino
    └── tag3/
        └── main.ino

---

## Débogage

1. **Problèmes de téléversement** :

   - S'Assurer que le port COM est correct et que le firmware est généré dans le bon dossier.
   - Utiliser le bouton FLASH de l'ESP32 avant d'exécuter à nouveau le téléversement.

---

## Notes

- Le script ne prend en charge que les cartes ESP32 et les fichiers `.ino`.
- Adapter le fichier `config.json` pour chaque ajout de nouvelles cartes ou pour chaque modification des scripts associés.
- Le dossier `build/` est recréé à chaque exécution pour éviter les conflits entre différentes cartes.

