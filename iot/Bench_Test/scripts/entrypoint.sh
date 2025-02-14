#!/bin/bash
set -e  # Stoppe le script en cas d'erreur

echo "[INFO] Initializing environment..."

# Rendre tous les scripts nécessaires exécutables (si d'autres fichiers doivent être exécutables)
chmod +x /app/Bench_Test/*.sh || true

# Lancer le script principal
echo "[INFO] Starting upload script..."
exec python /app/Bench_Test/upload_script.py "$@"
