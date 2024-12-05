#ifndef DATA_HANDLER_H
#define DATA_HANDLER_H

#include <Arduino.h>
#include <map>

// Data handling functions
void constructPackage(String address, float range);
void sendData(std::map<String, float> dataToSend);
String constructString(std::map<String, float> dataToSend);

#endif // DATA_HANDLER_H
