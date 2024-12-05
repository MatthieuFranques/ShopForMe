/**
 * @file main.ino
 * @brief This file must be uploaded to the ESP32, which will serve as the anchor.
 * @details Its role will be to make the Bluetooth link between the tags and the phone.
 * The anchor must receive the positions and send them.
 */

// ANCHOR
/** @brief SPI library for serial communication with peripherals. */
#include <SPI.h>
/** @brief DW1000Ranging library for UWB distance measurements. */
#include "DW1000Ranging.h"

// BLUETOOTH
/** @brief BLEDevice library for initializing and managing the BLE device. */
#include <BLEDevice.h>
/** @brief BLEServer library for managing BLE server functionality. */
#include <BLEServer.h>
/** @brief BLEUtils library for BLE utilities like UUID generation. */
#include <BLEUtils.h>
/** @brief BLE2902 library for managing BLE descriptors. */
#include <BLE2902.h>

// GENERAL
/** @brief C++ map library for storing key-value pairs. */
#include <map>
/** @brief ArduinoJson library for creating and manipulating JSON data. */
#include <ArduinoJson.h> 

// INIT FOR THE ANCHOR
#define ANCHOR_ADDRESS "82:17:5B:D5:A9:9A:E2:9C"
#define SPI_SCK 18
#define SPI_MISO 19
#define SPI_MOSI 23
#define DW_CS 4

const uint8_t PIN_RST = 27; // reset pin
const uint8_t PIN_IRQ = 34; // irq pin
const uint8_t PIN_SS = 4;   // spi select pin

const int MAX_TAGS = 3; // Maximum number of tags to track
unsigned long previousMillis = 0; // Variable to store the previous time

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

// INIT FOR THE BLUETOOTH
BLEServer *pServer = NULL;
BLECharacteristic *pCharacteristic = NULL;
bool deviceConnected = false; // Variable to track connection status
const int notifyInterval = 20000; // Notification interval in milliseconds (20 second)


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
    Serial.begin(115200);

    initAnchor();
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
    if (currentMillis - previousMillis >= 3000) {
        previousMillis = currentMillis; // Reset the previous time

        // Log distances for each active tag
        for (int i = 0; i < numTags; i++) {
            delay(500);
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
void constructPackage(String address, float range) {
    bool verif = true;

    // Ajouter une nouvelle paire clé-valeur
    if (dataToSend.size() <= 3)
        dataToSend.emplace(address, range);

    // Envoyer les données JSON lorsque toutes les positions de tags sont présentes
    if (dataToSend.size() == 3) {
        for (const auto& [key, value] : dataToSend) {
            if (value > 50.0f || value < 0.0f) { // Vérifier si une valeur dépasse 50
                verif = false;
                break;
            }
        }

        if (verif)
            sendData(dataToSend);
        else
            Serial.println("Data incorrect.");

        // Nettoyer la map pour la prochaine itération
        dataToSend.clear();
    }
}

void sendData(std::map<String, float> dataToSend) {
    Serial.println(constructString(dataToSend));
    if (deviceConnected) {
        // Construire la chaîne
        String data = constructString(dataToSend);
        const char* charArray = data.c_str();
        // Envoyer les données via BLE
        pCharacteristic->setValue(data.c_str()); // Cast en uint8_t* requis pour setValue
        pCharacteristic->notify();
    } else {
      Serial.println("Retry bluetooth connection");
    }
}

String constructString(std::map<String, float> dataToSend) {
    String data;
    size_t counter = 0;

    for (const auto& entry : dataToSend) {
        // On convertit en int avant de l'envoyer
        data += String(int(trunc(entry.second*100)));

        if (counter < dataToSend.size() - 1)
            data += "/";

        counter++;
    }
    Serial.println(data);

    return data;
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
        if (address[i] < 0x10)
            addressStr += "0";  // Add a zero before values below 0x10
        
        addressStr += String(address[i], HEX);  // Convert each byte to hex and add to the string
        if (i < 7)
            addressStr += ":";  // Add a ‘:’ between the bytes
    }

    return addressStr;
}