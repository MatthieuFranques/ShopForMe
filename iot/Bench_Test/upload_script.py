import serial.tools.list_ports
import json
import subprocess
import os
import time

# Fonction pour les couleurs
def colorize(text, color):
    colors = {
        "red": "\033[91m",
        "green": "\033[92m",
        "yellow": "\033[93m",
        "blue": "\033[94m",
        "magenta": "\033[95m",
        "reset": "\033[0m"
    }
    return f"{colors.get(color, colors['reset'])}{text}{colors['reset']}"

# Détection des ports COM
def detect_com_ports():
    import serial.tools.list_ports
    ports = serial.tools.list_ports.comports()
    return [port.device for port in ports]

# Détecter les ports COM disponibles
com_ports = detect_com_ports()
print(colorize(f"[INFO] Detected COM ports: {', '.join(com_ports)}", "magenta"))

# Charger la configuration
CONFIG_FILE = "config.json"
if not os.path.exists(CONFIG_FILE):
    print(colorize(f"[ERROR] Configuration file '{CONFIG_FILE}' not found.", "red"))
    exit(1)

with open(CONFIG_FILE, "r") as file:
    config = json.load(file)

print(colorize("[INFO] Configuration loaded.", "magenta"))
print(colorize("[INFO] Scanning for connected devices...", "magenta"))

# Dossier courant
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
print(f"BASE_DIR: {BASE_DIR}")
BUILD_BASE_DIR = os.path.join(BASE_DIR + "/Bench_Test", "build")
print(f"BUILD_BASE_DIR: {BUILD_BASE_DIR}")

# Créer le dossier de build principal s'il n'existe pas
os.makedirs(BUILD_BASE_DIR, exist_ok=True)

# Liste des ports disponibles
ports = serial.tools.list_ports.comports()
if not ports:
    print(colorize("[WARNING] No devices found.", "yellow"))
    exit(0)

# Initialiser le rapport
report = []

# Parcourir les ports disponibles
for port in ports:
    serial_number = port.serial_number
    print(colorize("[INFO] Detected device:", "magenta"))
    print(f"    Port: {port.device}")
    print(f"    Description: {port.description}")
    print(f"    Serial Number: {serial_number}")

    if serial_number in config:
        # Résoudre le chemin absolu à partir du chemin relatif
        target_path = os.path.abspath(os.path.join(BASE_DIR, config[serial_number])).replace("\\", "/")
        print(colorize(f"[INFO] Script assigned: {target_path}", "magenta"))
        print(colorize(f"[DEBUG] Using resolved path: {target_path}", "blue"))

        # Vérifier si le chemin est valide
        if not os.path.exists(target_path):
            print(colorize(f"[ERROR] Invalid script path: {target_path}", "red"))
            report.append({
                "serial_number": serial_number,
                "script": config[serial_number],
                "status": "ERROR",
                "message": f"Invalid script path: {target_path}"
            })
            continue

        # Si c'est un dossier, chercher le fichier .ino
        if os.path.isdir(target_path):
            print(colorize(f"[INFO] Detected project directory.", "magenta"))
            ino_files = [f for f in os.listdir(target_path) if f.endswith(".ino")]
            if not ino_files:
                print(colorize(f"[ERROR] No .ino file found in directory: {target_path}", "red"))
                report.append({
                    "serial_number": serial_number,
                    "script": config[serial_number],
                    "status": "ERROR",
                    "message": "No .ino file found in directory"
                })
                continue
            target_path = os.path.join(target_path, ino_files[0])
            print(colorize(f"[DEBUG] Found .ino file: {ino_files[0]}", "blue"))
        else:
            print(colorize(f"[INFO] Detected single file.", "magenta"))

        # Dossier de build pour cette carte
        card_build_dir = os.path.join(BUILD_BASE_DIR, serial_number)
        os.makedirs(card_build_dir, exist_ok=True)

        # Commande de compilation et téléversement
        build_and_upload_script = os.path.join(BASE_DIR, "scripts", "build_and_upload.sh")
        os.chmod(build_and_upload_script, 0o755)  # Rendre exécutable si ce n'est pas déjà le cas

        command = [
            "bash", build_and_upload_script,
            target_path, port.device, card_build_dir
        ]

        print(colorize(f"[INFO] Executing: {' '.join(command)}", "blue"))

        try:
            start_time = time.time()
            result = subprocess.run(command, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            print(result.stdout.decode())
            print(colorize(f"[SUCCESS] Build and upload completed in {time.time() - start_time:.2f} seconds.", "green"))
        except subprocess.CalledProcessError as e:
            print(colorize(f"[ERROR] Build and upload failed.", "red"))
            print(e.stderr.decode())
            report.append({
                "serial_number": serial_number,
                "script": config[serial_number],
                "status": "ERROR",
                "message": "Build and upload failed"
            })
            continue
    else:
        print(colorize(f"[WARNING] No script mapped for Serial Number: {serial_number} on {port.device}", "yellow"))
        report.append({
            "serial_number": serial_number,
            "script": "N/A",
            "status": "WARNING",
            "message": "No script mapped"
        })

print(colorize("[INFO] Process completed.", "magenta"))

# Afficher le rapport final
print(colorize("\n[INFO] Final Report:", "magenta"))
for entry in report:
    print(f"Serial Number: {entry['serial_number']}")
    print(f"    Script: {entry['script']}")
    print(f"    Status: {colorize(entry['status'], 'green' if entry['status'] == 'SUCCESS' else 'red')}")
    print(f"    Message: {entry['message']}\n")
