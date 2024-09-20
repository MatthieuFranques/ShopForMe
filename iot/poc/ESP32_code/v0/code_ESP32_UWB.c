#include <Arduino.h>
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEScan.h>
#include <BLEAdvertisedDevice.h>
#include <SPI.h>
#include <DW1000Ranging.h>

// Pins for ESP32 UWB
#define SS_PIN 5
#define RST_PIN 4
#define IRQ_PIN 2

// Configuration for DW1000
DW1000RangingClass DW1000Ranging;

BLEScan *pBLEScan;

void handleNewRange();
void handleNewDevice(DW1000Device *device);
void handleInactiveDevice(DW1000Device *device);

// Callback for BLE scan results
class MyAdvertisedDeviceCallbacks : public BLEAdvertisedDeviceCallbacks
{
    void onResult(BLEAdvertisedDevice advertisedDevice)
    {
        Serial.printf("Found Device: %s ", advertisedDevice.toString().c_str());
        Serial.printf("RSSI: %d\n", advertisedDevice.getRSSI());
    }
};

void setup()
{
    Serial.begin(115200);

    // Initialize Bluetooth
    BLEDevice::init("ESP32_BLE_Scanner");
    pBLEScan = BLEDevice::getScan();
    pBLEScan->setAdvertisedDeviceCallbacks(new MyAdvertisedDeviceCallbacks());
    pBLEScan->setActiveScan(true);
    pBLEScan->setInterval(100);
    pBLEScan->setWindow(99);

    // Initialize the SPI bus for UWB
    SPI.begin();

    // Initialize the DW1000 module
    DW1000Ranging.initCommunication(SS_PIN, RST_PIN, IRQ_PIN);
    DW1000Ranging.attachNewRange(handleNewRange);
    DW1000Ranging.attachNewDevice(handleNewDevice);
    DW1000Ranging.attachInactiveDevice(handleInactiveDevice);

    // Start as anchor (receiver)
    DW1000Ranging.startAsAnchor("DWANCHOR", DW1000.MODE_LONGDATA_RANGE_ACCURACY);
    // Or start as tag (transmitter) by uncommenting the next line
    // DW1000Ranging.startAsTag("DWTAG", DW1000.MODE_LONGDATA_RANGE_ACCURACY);

    Serial.println("DW1000 initialized as anchor (receiver)");
}

void loop()
{
    // Continuously update the DW1000 module
    DW1000Ranging.loop();

    // Perform BLE scan
    BLEScanResults foundDevices = pBLEScan->start(5, false);
    Serial.printf("Devices found: %d\n", foundDevices.getCount());
    pBLEScan->clearResults(); // delete results fromBLEScan buffer to release memory
}

// Callback for new range
void handleNewRange()
{
    Serial.print("UWB Distance: ");
    Serial.print(DW1000Ranging.getDistantDevice()->getRange());
    Serial.println(" m");
}

// Callback for new device discovery
void handleNewDevice(DW1000Device *device)
{
    Serial.print("New UWB device discovered: ");
    Serial.println(device->getShortAddress(), HEX);
}

// Callback for inactive device
void handleInactiveDevice(DW1000Device *device)
{
    Serial.print("UWB device inactive: ");
    Serial.println(device->getShortAddress(), HEX);
}
