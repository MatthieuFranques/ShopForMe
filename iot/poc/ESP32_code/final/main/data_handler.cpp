#include "data_handler.h"
#include <ArduinoJson.h>
#include <BLECharacteristic.h>

// Variable externe pour BLECharacteristic
extern BLECharacteristic *pCharacteristic;

// Implémentation de la fonction pour construire un paquet
void constructPackage(String address, float range)
{
    static std::map<String, float> dataToSend;

    if (dataToSend.size() < 3)
    {
        Serial.printf("Ajout de l'adresse %s avec distance %.2f\n", address.c_str(), range);
        dataToSend[address] = range;
    }

    if (dataToSend.size() == 3)
    {
        sendJson(dataToSend);
        dataToSend.clear(); // Réinitialiser les données après l'envoi
    }
}

// Implémentation de la fonction pour envoyer des données JSON via Bluetooth
void sendJson(std::map<String, float> dataToSend)
{
    if (pCharacteristic != nullptr)
    {
        String jsonString = constructJson(dataToSend);

        pCharacteristic->setValue(jsonString.c_str());
        pCharacteristic->notify();

        Serial.println("JSON envoyé :");
        Serial.println(jsonString);
    }
    else
    {
        Serial.println("Erreur : pCharacteristic est nul.");
    }
}

// Implémentation de la fonction pour construire un JSON
String constructJson(std::map<String, float> dataToSend)
{
    StaticJsonDocument<300> doc;
    doc["timestamp"] = millis() / 1000;

    JsonArray beaconArray = doc.createNestedArray("beacons");
    for (const auto &entry : dataToSend)
    {
        JsonObject beacon = beaconArray.createNestedObject();
        beacon["name"] = entry.first;
        beacon["distance"] = entry.second;
    }

    String jsonString;
    serializeJson(doc, jsonString);
    return jsonString;
}
