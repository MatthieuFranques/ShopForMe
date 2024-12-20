### commande pour compiler le code et obtenir les bin dans build/
arduino-cli compile --fqbn esp32:esp32:esp32 "C:/Users/aurel/Documents/epitech/Piscine/Msc1/Project MSc1/99 - ShopForMe/ShopForMe/delivery FRED/Esp-ShopForMe-Local/iot/app/main" --output-dir build

### lancer le bin en upload auto
python -m esptool --chip esp32 --port COM9 --baud 921600 write_flash -z 0x1000 build/main.ino.bin
