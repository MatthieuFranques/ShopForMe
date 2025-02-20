#include "data_handler.h"
#include <BLECharacteristic.h>

// External BLECharacteristic variable
extern BLECharacteristic *pCharacteristic;

// Function to construct and send a package
void constructPackage(String address, float range)
{
    static std::map<String, float> dataToSend;

    if (dataToSend.size() < 3)
    {
        dataToSend[address] = range;
    }

    if (dataToSend.size() == 3)
    {
        bool validData = true;

        for (const auto &[key, value] : dataToSend)
        {
            if (value > 50.0f || value < 0.0f)
            {
                validData = false;
                break;
            }
        }

        if (validData)
        {
            sendData(dataToSend);
        }
        else
        {
            Serial.println("Invalid data detected. Package not sent.");
        }

        dataToSend.clear(); // Clear data after sending
    }
}

// Function to send data via Bluetooth
void sendData(std::map<String, float> dataToSend)
{
    if (pCharacteristic != nullptr)
    {
        String constructedData = constructString(dataToSend);

        pCharacteristic->setValue(constructedData.c_str());
        pCharacteristic->notify();

        Serial.println("Data sent:");
        Serial.println(constructedData);
    }
    else
    {
        Serial.println("Error: BLE characteristic is null.");
    }
}

// Function to construct the data string
String constructString(std::map<String, float> dataToSend)
{
    String data;
    size_t counter = 0;

    for (const auto &entry : dataToSend)
    {
        data += String(int(trunc(entry.second * 100))); // Convert to integer representation
        if (counter < dataToSend.size() - 1)
        {
            data += "/";
        }
        counter++;
    }
    return data;
}
