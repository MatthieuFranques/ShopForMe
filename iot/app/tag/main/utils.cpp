/**
 * @file tag/main/utils.cpp
 * @brief Utility functions for logging distances and handling addresses.
 *
 * This file contains utility functions for logging distance values to the serial monitor,
 * formatting address values as strings, and printing addresses in a hexadecimal format.
 *
 * @date 03/2025
 */

#include "utils.h"

/**
 * @brief Logs the distance to the anchor to the serial monitor.
 *
 * This function formats and prints the distance to the anchor along with its address
 * in hexadecimal format. It ensures that the address is always displayed with 4 digits.
 *
 * @param address The address of the anchor in hexadecimal format.
 * @param range The range (distance) to the anchor in meters.
 */
void logDistances(uint16_t address, float range)
{
    Serial.print("Range to ANCHOR ");
    if (address < 0x1000) // Formatting to ensure to always have 4 hexadecimal digits
        Serial.print("0");
    Serial.print(address, HEX);

    Serial.print(" Distance: ");
    Serial.print(range);
    Serial.println(" m");
}

/**
 * @brief Converts an address into a formatted string.
 *
 * This function takes a 16-bit address and converts it into a string in hexadecimal format.
 * It ensures that the address is displayed with at least 4 hexadecimal digits.
 *
 * @param address The address to convert to a string.
 *
 * @return A string representation of the address in hexadecimal format.
 */
String getAddress(uint16_t address)
{
    String addressStr = "";
    if (address < 0x1000)
        addressStr += "0";
    addressStr += String(address, HEX);
    return addressStr;
}

/**
 * @brief Prints the address to the serial monitor in hexadecimal format.
 *
 * This function prints the address in hexadecimal format, ensuring that it is always
 * displayed with 4 digits.
 *
 * @param address The address to print.
 */
void printAddress(uint16_t address)
{
    if (address < 0x1000)
        Serial.print("0");
    Serial.print(address, HEX);
}