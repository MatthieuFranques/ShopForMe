import serial.tools.list_ports
import json
import subprocess
import os
import time

# Charger la configuration
CONFIG_FILE = "config.json"
if not os.path.exists(CONFIG_FILE):
    print(f"[ERROR] Configuration file '{CONFIG_FILE}' not found.")
    exit(1)

with open(CONFIG_FILE, "r") as file:
    config = json.load(file)

print("[INFO] Configuration loaded.")
print("[INFO] Scanning for connected devices...")

# Dossier courant
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
print(f"    BASE_DIR: {BASE_DIR}")
BUILD_BASE_DIR = os.path.join(BASE_DIR + "/Bench_Test", "build")
print(f"    BUILD_BASE_DIR: {BUILD_BASE_DIR}")

# Créer le dossier de build principal s'il n'existe pas
os.makedirs(BUILD_BASE_DIR, exist_ok=True)

# Liste des ports disponibles
ports = serial.tools.list_ports.comports()
if not ports:
    print("[WARNING] No devices found.")
    exit(0)

# Initialiser le rapport
report = []

# Parcourir les ports disponibles
for port in ports:
    serial_number = port.serial_number
    print(f"[INFO] Detected device:")
    print(f"    Port: {port.device}")
    print(f"    Description: {port.description}")
    print(f"    Serial Number: {serial_number}")

    if serial_number in config:
        # Résoudre le chemin absolu à partir du chemin relatif
        target_path = os.path.abspath(os.path.join(BASE_DIR, config[serial_number])).replace("\\", "/")
        print(f"    [INFO] Script assigned: {target_path}")
        print(f"[DEBUG] Using resolved path: {target_path}")

        # Vérifier si le chemin est valide
        if not os.path.exists(target_path):
            print(f"    [ERROR] Invalid script path: {target_path}")
            report.append({
                "serial_number": serial_number,
                "script": config[serial_number],
                "status": "ERROR",
                "message": f"Invalid script path: {target_path}"
            })
            continue

        # Si c'est un dossier, chercher le fichier .ino
        if os.path.isdir(target_path):
            print(f"    [INFO] Detected project directory.")
            ino_files = [f for f in os.listdir(target_path) if f.endswith(".ino")]
            if not ino_files:
                print(f"    [ERROR] No .ino file found in directory: {target_path}")
                report.append({
                    "serial_number": serial_number,
                    "script": config[serial_number],
                    "status": "ERROR",
                    "message": "No .ino file found in directory"
                })
                continue
            target_path = os.path.join(target_path, ino_files[0])
            print(f"    [DEBUG] Found .ino file: {ino_files[0]}")
        else:
            print(f"    [INFO] Detected single file.")

        # Dossier de build pour cette carte
        card_build_dir = os.path.join(BUILD_BASE_DIR, serial_number)
        os.makedirs(card_build_dir, exist_ok=True)

        # Commande de compilation
        compile_command = [
            "arduino-cli", "compile",
            "--fqbn", "esp32:esp32:esp32",
            "--output-dir", card_build_dir,
            target_path
        ]

        # Fichier binaire compilé
        firmware_path = os.path.join(card_build_dir, "main.ino.bin")

        # Commande d'upload avec esptool
        upload_command = [
            "python", "-m", "esptool",
            "--chip", "esp32",
            "--port", port.device,
            "--baud", "921600",
            "write_flash", "-z", "0x1000", firmware_path
        ]

        # Debugging pour afficher les commandes
        print(f"[DEBUG] Compile command: {' '.join(compile_command)}")
        print(f"[DEBUG] Upload command: {' '.join(upload_command)}")

        # Exécuter la compilation
        print(f"    [INFO] Starting compilation for {target_path}...")
        try:
            start_time = time.time()
            result = subprocess.run(compile_command, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            print(result.stdout.decode())  # Afficher les logs de compilation
            print(f"    [SUCCESS] Compilation completed in {time.time() - start_time:.2f} seconds.")
        except subprocess.CalledProcessError as e:
            print(f"    [ERROR] Compilation failed for {target_path}.")
            print(e.stderr.decode())  # Afficher les erreurs
            report.append({
                "serial_number": serial_number,
                "script": config[serial_number],
                "status": "ERROR",
                "message": "Compilation failed"
            })
            continue

        # Vérifier si le fichier binaire a été généré
        if not os.path.exists(firmware_path):
            print(f"    [ERROR] Compiled firmware not found: {firmware_path}")
            report.append({
                "serial_number": serial_number,
                "script": config[serial_number],
                "status": "ERROR",
                "message": "Compiled firmware not found"
            })
            continue

        # Exécuter le téléversement
        print(f"    [INFO] Starting upload to {port.device}...")
        try:
            start_time = time.time()
            result = subprocess.run(upload_command, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            print(result.stdout.decode())  # Afficher les logs de téléversement
            print(f"    [SUCCESS] Upload completed in {time.time() - start_time:.2f} seconds.")
            report.append({
                "serial_number": serial_number,
                "script": config[serial_number],
                "status": "SUCCESS",
                "message": "Upload completed"
            })
        except subprocess.CalledProcessError as e:
            print(f"    [ERROR] Upload failed for {firmware_path}.")
            print(e.stderr.decode())  # Afficher les erreurs
            report.append({
                "serial_number": serial_number,
                "script": config[serial_number],
                "status": "ERROR",
                "message": "Upload failed"
            })
    else:
        print(f"    [WARNING] No script mapped for Serial Number: {serial_number} on {port.device}")
        report.append({
            "serial_number": serial_number,
            "script": "N/A",
            "status": "WARNING",
            "message": "No script mapped"
        })

print("[INFO] Process completed.")

# Afficher le rapport final
print("\n[INFO] Final Report:")
for entry in report:
    print(f"Serial Number: {entry['serial_number']}")
    print(f"    Script: {entry['script']}")
    print(f"    Status: {entry['status']}")
    print(f"    Message: {entry['message']}\n")
