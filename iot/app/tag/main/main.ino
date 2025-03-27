/**
 * @file tag/main/main.ino
 * @brief Main program for initializing UWB tag and Bluetooth service.
 *
 * This file contains the main setup and loop functions for the program. It initializes
 * the UWB tag and Bluetooth service in the setup function and continuously handles
 * the UWB tag and Bluetooth communication in the loop function.
 *
 * @date 03/2025
 */

#include "uwb_tag.h"
#include "bluetooth_service.h"

/**
 * @brief Initializes the system by setting up the UWB tag and Bluetooth service.
 *
 * The setup function is called once during program initialization. It begins serial
 * communication, initializes the UWB tag, and initializes the Bluetooth service.
 *
 * @note This function is called once when the ESP32 starts.
 */
void setup()
{
    Serial.begin(115200);  ///< Start serial communication for debugging

    initTag();             ///< Initialize the UWB tag for distance measurement
    initBluetooth();       ///< Initialize Bluetooth service for communication
}

/**
 * @brief Main loop that continuously handles UWB tag and Bluetooth communication.
 *
 * The loop function is called repeatedly. It calls functions to handle the UWB tag
 * and Bluetooth communication. This ensures that data from the UWB tag is processed
 * and sent via Bluetooth as needed.
 *
 * @note This function is called repeatedly after the setup function.
 */
void loop()
{
    handleTagLoop();       ///< Handle the UWB tag communication and processing
}