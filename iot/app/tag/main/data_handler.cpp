/**
 * @file tag/main/data_handler.cpp
 * @brief Data handler for constructing and sending packages via Bluetooth.
 *
 * This file contains functions for constructing data packages, validating them,
 * and sending them via Bluetooth using BLE characteristics. It handles the collection
 * of data in a map, ensuring valid data before transmission, and constructs the
 * appropriate data string to be sent.
 *
 * @date 03/2025
 */

#include "data_handler.h"
#include <BLECharacteristic.h>

// External BLECharacteristic variable
extern BLECharacteristic *pCharacteristic;

/**
 * @brief Constructs a package of data and sends it when valid.
 *
 * This function collects data from various sources, stores it in a map, and
 * sends the data when three valid entries are collected. It ensures that the data
 * is within an acceptable range (0.0 to 50.0). If invalid data is detected,
 * the package is not sent.
 *
 * @param address The address of the device sending the range data.
 * @param range The range value to be associated with the address.
 *
 * @note The function clears the map after sending a valid package.
 */
void constructPackage(String address, float range)
{
    static std::map<String, float> dataToSend;

    // Add new data to the map if there is room
    if (dataToSend.size() < 3)
    {
        dataToSend[address] = range;
    }

    // Once 3 pieces of data are collected, check validity
    if (dataToSend.size() == 3)
    {
        bool validData = true;

        // Validate the collected data
        for (const auto &[key, value] : dataToSend)
        {
            if (value > 50.0f || value < 0.0f)
            {
                validData = false;
                break;
            }
        }

        // Send data if valid, otherwise print an error message
        if (validData)
        {
            sendData(dataToSend);
        }
        else
        {
            Serial.println("Invalid data detected. Package not sent.");
        }

        // Clear data after sending
        dataToSend.clear();
    }
}

/**
 * @brief Sends data via Bluetooth using the BLE characteristic.
 *
 * This function converts the data into a string format and sends it via
 * the provided BLE characteristic using the `notify` method. If the BLE
 * characteristic is not initialized, it will print an error message.
 *
 * @param dataToSend A map containing the data to be sent, where keys are addresses
 * and values are range values.
 *
 * @note This function prints the constructed data string to the serial monitor
 * after sending it.
 */
void sendData(std::map<String, float> dataToSend)
{
    if (pCharacteristic != nullptr)
    {
        // Construct the data string from the map
        String constructedData = constructString(dataToSend);

        // Set and notify the BLE characteristic with the constructed data
        pCharacteristic->setValue(constructedData.c_str());
        pCharacteristic->notify();

        // Log the data sent
        Serial.println("Data sent:");
        Serial.println(constructedData);
    }
    else
    {
        Serial.println("Error: BLE characteristic is null.");
    }
}

/**
 * @brief Constructs a string from a map of data to be sent.
 *
 * This function takes a map of data and converts it into a string format. The data
 * is represented as an integer (multiplied by 100 to avoid decimal) for more precise transmission.
 * The entries are separated by a forward slash ('/').
 *
 * @param dataToSend The map containing the data to be converted into a string.
 *
 * @return A string representing the data.
 */

String constructString(std::map<String, float> dataToSend)
{
    String data;
    float anchorDistances[3] = {-1, -1, -1}; // Table of distances, -1 means ‘not yet received’.

    // Desired order of anchors
    const String anchorOrder[3] = {"07D", "445A", "119E"};

    Serial.println("=== Entrée dataToSend ===");
    for (const auto &entry : dataToSend)
    {
        // Associate the distance with the correct anchor by browsing anchorOrder
        for (int i = 0; i < 3; i++)
        {
            if (entry.first.equalsIgnoreCase(anchorOrder[i]))
            {
                anchorDistances[i] = entry.second;
                break;
            }
        }
    }

    for (int i = 0; i < 3; i++)
    {
        if (anchorDistances[i] >= 0)
        {
            data += String(int(trunc(anchorDistances[i] * 100)));

            if (i < 2)
                data += "/";
        }
    }

    return data;
}