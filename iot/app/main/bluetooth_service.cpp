#include "bluetooth_service.h"
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include "data_handler.h"

BLEServer *pServer = NULL;
BLECharacteristic *pCharacteristic = NULL;
bool deviceConnected = false;

class MyServerCallbacks : public BLEServerCallbacks
{
    void onConnect(BLEServer *pServer) { deviceConnected = true; }
    void onDisconnect(BLEServer *pServer) { deviceConnected = false; }
};

void initBluetooth()
{
    BLEDevice::init("ESP32_BLE");
    pServer = BLEDevice::createServer();
    pServer->setCallbacks(new MyServerCallbacks());

    BLEService *pService = pServer->createService(BLEUUID((uint16_t)0x180D));
    pCharacteristic = pService->createCharacteristic(
        BLEUUID((uint16_t)0x2A37),
        BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY);

    pCharacteristic->addDescriptor(new BLE2902());
    pService->start();
    pServer->getAdvertising()->start();
    Serial.println("Bluetooth initialized.");
}

void handleBluetoothLoop()
{
    if (deviceConnected)
    {
        // Logic to handle Bluetooth notifications (if needed)
    }
}
