#ifndef DATA_HANDLER_H
#define DATA_HANDLER_H

#include <Arduino.h>
#include <map>

// Déclaration des fonctions de gestion des données
void constructPackage(String address, float range);
void sendJson(std::map<String, float> dataToSend);
String constructJson(std::map<String, float> dataToSend);

#endif // DATA_HANDLER_H
