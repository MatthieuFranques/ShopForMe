#include "utils.h"

void logDistances(uint16_t address, float range)
{
    Serial.print("Range to ANCHOR ");
    if (address < 0x1000) // Formatting to ensure you always have 4 hexadecimal digits
        Serial.print("0");
    Serial.print(address, HEX);

    Serial.print(" Distance: ");
    Serial.print(range);
    Serial.println(" m");
}

String getAddress(uint16_t address)
{
    String addressStr = "";
    if (address < 0x1000)
        addressStr += "0";
    addressStr += String(address, HEX);
    return addressStr;
}

void printAddress(uint16_t address)
{
    if (address < 0x1000)
        Serial.print("0");
    Serial.print(address, HEX);
}