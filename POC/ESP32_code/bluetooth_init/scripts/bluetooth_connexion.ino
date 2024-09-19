#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

BLEServer *pServer = NULL;
BLECharacteristic *pCharacteristic = NULL;
bool deviceConnected = false; // Variable to track connection status
const int notifyInterval = 1000; // Notification interval in milliseconds (1 second)

// Class to handle BLE server events for connection and disconnection
class MyServerCallbacks: public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) {
    deviceConnected = true; // Update status when a device connects
  }

  void onDisconnect(BLEServer* pServer) {
    deviceConnected = false; // Update status when a device disconnects
  }
};

void setup() {
  Serial.begin(115200);
  BLEDevice::init("ESP32_BLE"); // Name of BLE device

  pServer = BLEDevice::createServer(); // Create a BLE server
  pServer->setCallbacks(new MyServerCallbacks()); // Set callbacks for connection events

  // Create a BLE service with a specific UUID
  BLEService *pService = pServer->createService(BLEUUID((uint16_t)0x180D));

  // Create a BLE characteristic with read and notify properties
  pCharacteristic = pService->createCharacteristic(
                      BLEUUID((uint16_t)0x2A37),
                      BLECharacteristic::PROPERTY_READ |
                      BLECharacteristic::PROPERTY_NOTIFY
                    );

  pCharacteristic->setValue("-- TEST Notification from ESP32 --"); // Set the initial value of the characteristic

  // Start the BLE service
  pService->start();

  // Start advertising so the device can be discovered
  BLEAdvertising *pAdvertising = pServer->getAdvertising();
  pAdvertising->start();
}

void loop() {
  // If a device is connected, send a notification every 'notifyInterval' milliseconds
  if (deviceConnected) {
    pCharacteristic->setValue("-- Notification from ESP32 --"); // Update the value of the characteristic
    pCharacteristic->notify(); // Send a notification with the new value
    delay(notifyInterval); // Wait before sending the next notification
  }
}
