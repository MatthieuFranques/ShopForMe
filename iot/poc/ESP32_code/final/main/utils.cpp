#include "utils.h"

void logDistances(const uint8_t *address, float range)
{
    Serial.print("Range to TAG ");
    for (int i = 0; i < 8; i++)
    {
        if (address[i] < 0x10)
            Serial.print("0");
        Serial.print(address[i], HEX);
        if (i < 7)
            Serial.print(":");
    }
    Serial.print(" Distance: ");
    Serial.print(range);
    Serial.println(" m");
}

String getAddress(const uint8_t *address)
{
    String addressStr = "";
    for (int i = 0; i < 8; i++)
    {
        if (address[i] < 0x10)
            addressStr += "0";
        addressStr += String(address[i], HEX);
        if (i < 7)
            addressStr += ":";
    }
    return addressStr;
}

void printAddress(const uint8_t *address) // Ajoutez cette définition
{
    for (int i = 0; i < 8; i++)
    {
        if (address[i] < 0x10)
            Serial.print("0");
        Serial.print(address[i], HEX);
        if (i < 7)
            Serial.print(":");
    }
}
