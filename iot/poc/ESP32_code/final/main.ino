/**
 * @file main.ino
 * @brief This file must be uploaded to the ESP32, which will serve as the anchor.
 * @details Its role will be to make the Bluetooth link between the tags and the phone.
 * The anchor must receive the positions and send them.
 */

// ANCHOR
#include <SPI.h>
#include "DW1000Ranging.h"

// BLUETOOTH
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

// GENERAL
#include <map>
#include <ArduinoJson.h> 

#define ANCHOR_ADDRESS "82:17:5B:D5:A9:9A:E2:9C"
#define SPI_SCK 18
#define SPI_MISO 19
#define SPI_MOSI 23
#define DW_CS 4

// INIT FOR THE BLUETOOTH
BLEServer *pServer = NULL;
BLECharacteristic *pCharacteristic = NULL;
bool deviceConnected = false; // Variable to track connection status
const int notifyInterval = 20000; // Notification interval in milliseconds (20 second)

// INIT FOR THE ANCHOR
const uint8_t PIN_RST = 27; // reset pin
const uint8_t PIN_IRQ = 34; // irq pin
const uint8_t PIN_SS = 4;   // spi select pin

const int MAX_TAGS = 3; // Maximum number of tags to track
unsigned long previousMillis = 0; // Variable to store the previous time
const long interval = 1000;       // Log interval (1 second)

/// @brief Addition of a constant offset of 70 cm
const float DISTANCE_OFFSET = 0.7;

/// @brief Structure for storing tag distances
struct Tag {
    uint8_t address[8]; // Use an array of 8 bytes for the long address
    float distance;
    bool active;
};

Tag tags[MAX_TAGS];
int numTags = 0;

/// @brief Data to be sent in JSON format to the application
std::map<String, float> dataToSend;

/// @brief Class to handle BLE server events for connection and disconnection
class MyServerCallbacks: public BLEServerCallbacks {

    void onConnect(BLEServer* pServer) {
        deviceConnected = true; // Update status when a device connects
    }

    void onDisconnect(BLEServer* pServer) {
        deviceConnected = false; // Update status when a device disconnects
    }
};

/**
 * @brief Initialise the necessary modules (Bluetooth and UWB).
 * @details This function is called once when the programme is started.
 */
void setup() {
    
    initBluetooth();
}

/**
 * @brief Main loop executed continuously.
 * @details This function reads distances and sends them via Bluetooth.
 */
void loop() {
    DW1000Ranging.loop();

    unsigned long currentMillis = millis();

    // If a second has passed, log the distances
    if (currentMillis - previousMillis >= interval) {
        previousMillis = currentMillis; // Reset the previous time

        // Log distances for each active tag
        for (int i = 0; i < numTags; i++) {
            if (tags[i].active) {
                logDistances(tags[i].address, tags[i].distance);

                constructPackage(getAddress(tags[i].address), tags[i].distance);
            }
        }
    }
}

/**
 * @brief Initializes the ESP32 as an anchor in the UWB positioning system.
 * @details Configures SPI communications, initializes DW1000Ranging library, 
 *          and attach callbacks to manage distances and new devices, 
 *          and inactive devices. The ESP32 starts in anchor mode with a defined address.
 */
void initAnchor() {

    Serial.begin(115200);
    delay(1000);
    Serial.println("Starting as ANCHOR...");

    SPI.begin(SPI_SCK, SPI_MISO, SPI_MOSI);
    DW1000Ranging.initCommunication(PIN_RST, PIN_SS, PIN_IRQ); // Reset, CS, IRQ pin
    DW1000Ranging.attachNewRange(newRange);
    DW1000Ranging.attachNewDevice(newDevice);
    DW1000Ranging.attachInactiveDevice(inactiveDevice);

    DW1000Ranging.startAsAnchor(ANCHOR_ADDRESS, DW1000.MODE_LONGDATA_RANGE_LOWPOWER);
    Serial.println("ANCHOR initialized and running...");
}

/**
 * @brief Initializes the Bluetooth Low Energy (BLE) module on the ESP32.
 * @details Configures and starts the BLE server, a service, and a feature,  
 *          then launch advertising to make the ESP32 detectable by other devices.
 * 
 * @note This method must only be called once in the `setup` function.
 * 
 * @remarks The method uses the Arduino BLE library to manage BLE connectivity.
 */
void initBluetooth() {

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

    pCharacteristic->addDescriptor(new BLE2902());

    pCharacteristic->setValue("-- TEST Notification from ESP32 --"); // Set the initial value of the characteristic

    // Start the BLE service
    pService->start();

    // Start advertising so the device can be discovered
    BLEAdvertising *pAdvertising = pServer->getAdvertising();
    pAdvertising->start();

    Serial.print("BLUETOOTH initialized and detectable...");
}

/**
 * @brief Updates or adds a remote device to the list of tracked beacons with its current distance.
 * @details This method retrieves information from a remote tag (address and distance) via the `DW1000Ranging` library. 
 *          If the tag already exists in the list, it updates its distance and marks the tag as active. 
 *          If the tag is not found and there is still room in the list, it is added as a new tag.
 */
void newRange() {
    DW1000Device* distantDevice = DW1000Ranging.getDistantDevice();
    uint8_t* address = distantDevice->getByteAddress(); // Use the long address as an array of bytes
    float range = distantDevice->getRange();

    // Apply the 70 cm offset
    range -= DISTANCE_OFFSET;

    // Check if the tag is already in the table
    bool found = false;
    for (int i = 0; i < numTags; i++) {
        if (memcmp(tags[i].address, address, 8) == 0) {
            tags[i].distance = range; // Update distance
            tags[i].active = true; // Mark the tag as active
            found = true;
            break;
        }
    }

    // Add a new tag if not found
    if (!found && numTags < MAX_TAGS) {
        memcpy(tags[numTags].address, address, 8);
        tags[numTags].distance = range;
        tags[numTags].active = true; // Mark the tag as active
        numTags++;
    }
}

/**
 * @brief Checks whether a device is already in the list of tracked beacons and displays a message if the device is new.
 * @details This method compares the device address with those of existing tags in the list. 
 *          If the address is not found, it displays a message indicating that a new device has been added.
 * 
 * @param[in] device Pointer to a `DW1000Device` object representing the detected device. 
 *                   The device address is used for verification.
 */
void newDevice(DW1000Device *device) {
    uint8_t* address = device->getByteAddress(); // Use the long address as an array of bytes
    bool found = false;
    for (int i = 0; i < numTags; i++) {
        if (memcmp(tags[i].address, address, 8) == 0) {
            found = true;
            break;
        }
    }
    if (!found) {
        Serial.print("ANCHOR: New device added -> ");
        printAddress(address);
    }
}

/**
 * @brief Removes an inactive device from the list of tracked beacons.
 * @details This method checks whether the address of the inactive device is present in the list of tags. 
 *          If it is found, the device is removed from the list, and the remaining entries are reorganised.
 * 
 * @param[in] device Pointer to a `DW1000Device` object representing the inactive device.
 * 
 * @note The list of tags is assumed to be stored in a `tags` array with a global counter `numTags`.
 *       Deletion involves shifting elements in the table to maintain consistency.
 */
void inactiveDevice(DW1000Device *device) {
    uint8_t* address = device->getByteAddress(); // Address of inactive device
    bool found = false;

    for (int i = 0; i < numTags; i++) {
      
        if (memcmp(tags[i].address, address, 8) == 0) {
            Serial.print("ANCHOR: Inactive device removed -> ");
            printAddress(address);
            found = true;

            // Shift the remaining tags to delete the inactive tag
            for (int j = i; j < numTags - 1; j++) {
                tags[j] = tags[j + 1];
            }

            numTags--; // Reduce the tag counter
            break; // Exit the loop after deletion
        }
    }

    if (!found) {
        Serial.println("ANCHOR: Inactive device not found in tags list.");
    }
}

/**
 * @brief Sends a JSON notification via Bluetooth
 * @details This method constructs a JSON string from the data supplied and sends it to
 *          to a device connected via Bluetooth using the notification function.
 * 
 * @param[in] dataToSend A map containing the data to be included in the JSON. 
 *                       The keys (String) represent the addresses of the beacons, 
 *                       and the values (float) represent the associated distances.
 * 
 * @note The method only sends if a device is connected to the BLE device.
 */
void sendJson(std::map<String, float> dataToSend) {
    // If a device is connected, send a notification every 'notifyInterval' milliseconds
    if (deviceConnected) {

        String jsonString = constructJson(dataToSend);

        // Mettre à jour la valeur de la caractéristique avec la chaîne JSON
        pCharacteristic->setValue(jsonString.c_str());

        // Notify connected device with the new JSON value
        pCharacteristic->notify();

        // Wait before sending the next notification
        delay(notifyInterval);
    }
}

/**
 * @brief Builds a data package and sends a JSON when all the data has been retrieved (the 3 tags).
 * @details This method adds a new entry (address and distance) to a data map. 
 *          When the map contains exactly three entries, it generates and sends a JSON via the `sendJson` method, 
 *          then clean up the map for resending.
 * 
 * @param[in] address The address (identifier) of the tag in string form.
 * @param[in] range The distance associated with the beacon, expressed in metres.
 * 
 * @note This method assumes that a maximum of three tags must be included in the package before sending.
 * 
 * @code
 * // Example of use :
 * constructPackage("Beacon1", 3.14);
 * constructPackage("Beacon2", 2.71);
 * constructPackage("Beacon3", 1.61);
 * @endcode
 */
void constructPackage(String address, float range)  {
    // Add a new key-value entry
    if (dataToSend.size() <= 3)
        dataToSend.emplace(address, range);
    
    // Send the JSON when it contains all three tag positions
    if (dataToSend.size() == 3) {
        sendJson(dataToSend);

        // Cleaning up the data to be sent for the next round
        dataToSend.clear();
    }
}

/**
 * @brief Builds a JSON string from the data supplied.
 * @details This method generates a JSON string containing a timestamp and a list of objects representing tags,
 *          each tag having a name (address) and an associated distance.
 * 
 * @param[in] dataToSend A map containing the data to be included in the JSON. 
 *                       Keys (String) represent the addresses of the beacons, 
 *                       and the values (float) represent the associated distances.
 * @return A JSON string representing the data in the following format :
 * @code
 * {
 *     "timestamp": 123456,
 *     "beacons": [
 *         {"name": "Beacon1", "distance": 3.14},
 *         {"name": "Beacon2", "distance": 2.71}
 *     ]
 * }
 * @endcode
 */
String constructJson(std::map<String, float> dataToSend) {
    // Create a JSON object
    StaticJsonDocument<300> doc;  // 300-byte capacity

    // Get the current time in timestamp (in seconds)
    unsigned long timestamp = millis() / 1000;

    // Add the timestamp to the JSON document
    doc["timestamp"] = timestamp;

    // Create a table for the data (name, distance)
    JsonArray beaconArray = doc.createNestedArray("beacons");

    // Browse the map and add each element as an object in the table
    for (const auto& entry : dataToSend) {
        // Create an object for each beacon
        JsonObject beacon = beaconArray.createNestedObject();

        beacon["name"] = entry.first;  // ‘name’ is the address (key to the map)
        beacon["distance"] = entry.second;  // ‘distance’ is the value of the map
    }

    // Convert JSON document to string
    String jsonString;
    serializeJson(doc, jsonString);  // Serialise the JSON object in a string

    return jsonString;
}

/**
 * @brief Displays the distance calculated between an anchor and a UWB tag.
 * @details This method displays the beacon address and the corresponding distance on the serial monitor.
 * 
 * @param[in] address Pointer to the address of the UWB tag (byte array).
 * @param[in] range Calculated distance between the anchor and the beacon, in metres.
 */
void logDistances(const uint8_t* address, float range) {
    Serial.print("ANCHOR: Range to TAG ");
    printAddress(address);
    Serial.print("\t Range: ");
    Serial.print(range);
    Serial.print(" m");
    Serial.println();
}

/**
 * @brief Displays a UWB address in readable hexadecimal format.
 * 
 * @param[in] address Pointer to the byte array containing the UWB address (8 bytes).
 */
void printAddress(const uint8_t* address) {
    for (int i = 0; i < 8; i++) {
        if (address[i] < 0x10) Serial.print("0");
        Serial.print(address[i], HEX);
        if (i < 7) Serial.print(":");
    }
}

/**
 * @brief Converts a UWB address into a readable hexadecimal string.
 * 
 * @param[in] address Pointer to the byte array containing the UWB address (8 bytes).
 * @return A formatted string representing the address in hexadecimal format.
 */
String getAddress(const uint8_t* address) {
    String addressStr = "";
    for (int i = 0; i < 8; i++) {
        if (address[i] < 0x10) {
            addressStr += "0";  // Add a zero before values below 0x10
        }
        addressStr += String(address[i], HEX);  // Convert each byte to hex and add to the string
        if (i < 7) {
            addressStr += ":";  // Add a ‘:’ between the bytes
        }
    }

    return addressStr;
}