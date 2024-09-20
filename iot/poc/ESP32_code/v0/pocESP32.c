#include <NimBLEDevice.h>
#include <NimBLEScan.h>
#include <NimBLEAdvertisedDevice.h>
#include <WiFi.h>

const char *ssid = "";                       // remplacer par le SSID du PA
const char *password = "";                   // remplacer par le MDP du PA
const char *targetMAC = "11:22:33:44:55:66"; // Remplacez par l'adresse MAC que vous recherchez

void setup()
{
    Serial.begin(115200);
    WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED)
    {
        delay(15000);
    }

    Serial.println("Connecté au WiFi");
    NimBLEDevice::init("");
    Serial.println("BLE Initialiser");
}

void loop()
{

    if (WiFi.status() != WL_CONNECTED)
    {
        WiFi.begin(ssid, password);
        delay(15000);
    }
    Serial.println("Boucle loop début!");
    NimBLEScan *pNimBLEScan = NimBLEDevice::getScan();
    pNimBLEScan->setActiveScan(true);
    NimBLEScanResults foundDevices = pNimBLEScan->start(5);

    for (int i = 0; i < foundDevices.getCount(); i++)
    {
        NimBLEAdvertisedDevice advertisedDevice = foundDevices.getDevice(i);
        Serial.printf("Adresse MAC: %s, RSSI: %d, Nom: %s\n", advertisedDevice.getAddress().toString().c_str(), advertisedDevice.getRSSI(), advertisedDevice.getName().c_str());
    }
    delay(5000); // temps en millisecondes.
}
