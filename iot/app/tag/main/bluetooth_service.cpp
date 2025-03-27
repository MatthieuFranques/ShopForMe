/**
 * @file tag/main/bluetooth_service.cpp
 * @brief Implementation of Bluetooth service for ESP32.
 *
 * This file contains the initialization of the Bluetooth Low Energy (BLE) service for an ESP32,
 * handling of device connections and disconnections, as well as sending notifications.
 *
 * @date 03/2025
 */

#include "bluetooth_service.h"
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

// BLE object declarations
BLEServer *pServer = NULL; /**< Pointer to the BLE server object */
BLECharacteristic *pCharacteristic = NULL; /**< Pointer to the BLE characteristic object */
bool deviceConnected = false; /**< Device connection state */

/**
 * @class MyServerCallbacks
 * @brief Callback class for handling BLE connection and disconnection events.
 *
 * This class inherits from `BLEServerCallbacks` and allows detection of when a device
 * connects or disconnects from the BLE server.
 */
class MyServerCallbacks : public BLEServerCallbacks
{
    /**
     * @brief Called when a device connects to the server.
     *
     * This method sets `deviceConnected` to `true` when a connection is established.
     * @param pServer Pointer to the BLE server object.
     */
    void onConnect(BLEServer *pServer) { deviceConnected = true; }

    /**
     * @brief Called when a device disconnects from the server.
     *
     * This method sets `deviceConnected` to `false` when the connection is lost.
     * @param pServer Pointer to the BLE server object.
     */
    void onDisconnect(BLEServer *pServer) { deviceConnected = false; }
};

/**
 * @brief Initializes Bluetooth on the ESP32.
 *
 * This function configures and starts the BLE server on the ESP32. It also creates
 * a BLE characteristic (read and notify) within a service specified by its UUID.
 *
 * @note The BLE server is started and begins advertising its availability.
 */
void initBluetooth()
{
    BLEDevice::init("ESP32_BLE"); /**< Initializes the BLE device with the name "ESP32_BLE" */
    pServer = BLEDevice::createServer(); /**< Creates the BLE server object */
    pServer->setCallbacks(new MyServerCallbacks()); /**< Assigns callbacks to handle connection/disconnection events */

    BLEService *pService = pServer->createService(BLEUUID((uint16_t)0x180D)); /**< Creates a BLE service with the specified UUID */
    pCharacteristic = pService->createCharacteristic(
        BLEUUID((uint16_t)0x2A37), /**< Creates a characteristic with a specific UUID */
        BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY /**< Defines the properties of the characteristic (read and notify) */
    );

    pCharacteristic->addDescriptor(new BLE2902()); /**< Adds a descriptor for notifications */
    pService->start(); /**< Starts the BLE service */
    pServer->getAdvertising()->start(); /**< Starts BLE advertising to allow devices to connect */

    Serial.println("Bluetooth initialized."); /**< Prints a message to the serial monitor */
}

/**
 * @brief Bluetooth loop function to handle the connection state.
 *
 * This function checks if a device is connected and can be used to add
 * additional logic for notifications or other Bluetooth interactions.
 *
 * @note Bluetooth notification handling can be added here if needed.
 */
void handleBluetoothLoop()
{
    if (deviceConnected)
    {
        //TODO Logic to handle Bluetooth notifications (if needed)
    }
}
