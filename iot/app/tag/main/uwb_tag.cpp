/**
 * @file tag/main/uwb_tag.cpp
 * @brief Source file for handling UWB (Ultra Wideband) tag operations.
 * 
 * This file contains functions to initialize the UWB tag, manage the tag's range 
 * measurements, and handle devices in the range. It interfaces with the DW1000 
 * device to handle distance measurements, devices, and the package construction 
 * for sending the data via Bluetooth.
 *
 * @date 03/2025
 */

#include "uwb_tag.h"
#include "utils.h"
#include "data_handler.h"

// Global variables
Anchor anchors[3]; /**< Array to store anchor devices. */
int numAnchors = 0; /**< Number of active anchors. */
unsigned long previousMillis = 0; /**< Stores the previous time for periodic tasks. */
char TAG_ADDRESS[] = "82:17:5B:D5:A9:9A:E2:9C"; /**< Address of the tag. */

/**
 * @brief Initializes the UWB tag.
 * 
 * This function initializes the SPI communication, sets up the DW1000 ranging 
 * module, and configures the tag with a specified address. The tag is then 
 * started to begin distance measurements.
 * 
 * @note This function must be called during setup to initialize the tag before use.
 */
void initTag()
{
    SPI.begin(SPI_SCK, SPI_MISO, SPI_MOSI); /**< Initialize SPI communication. */
    DW1000Ranging.initCommunication(PIN_RST, PIN_SS, PIN_IRQ); /**< Initialize DW1000 communication. */
    DW1000Ranging.attachNewRange(newRange); /**< Attach callback for new range. */
    DW1000Ranging.attachNewDevice(newDevice); /**< Attach callback for new device. */
    DW1000Ranging.attachInactiveDevice(inactiveDevice); /**< Attach callback for inactive devices. */
    DW1000Ranging.startAsTag(TAG_ADDRESS, DW1000.MODE_LONGDATA_RANGE_LOWPOWER, false); /**< Start the tag in low power mode. */
    Serial.println("Tag initialized and running..."); /**< Print confirmation to serial. */
}

/**
 * @brief Handles the tag loop.
 * 
 * This function is called periodically to handle UWB ranging logic. It checks 
 * the time interval and logs the distances to the anchors. The data is then 
 * sent to the data handler for packaging and sending via Bluetooth.
 * 
 * @note This function should be called in the main loop to continuously handle 
 *       the tag's behavior.
 */
void handleTagLoop()
{
    DW1000Ranging.loop(); /**< Process DW1000 ranging events. */
    unsigned long currentMillis = millis();

    // If it's time to log and send data, execute the following
    if (currentMillis - previousMillis >= interval)
    {
        previousMillis = currentMillis; /**< Update the previous time. */
        
        // Iterate through anchors and process data
        for (int i = 0; i < numAnchors; i++)
        {
            logDistances(anchors[i].address, anchors[i].distance); /**< Log the anchor's distance. */
            constructPackage(getAddress(anchors[i].address), anchors[i].distance); /**< Construct and send data package. */
        }
    }
}

/**
 * @brief Callback function when a new range is available.
 * 
 * This function is called when a new range measurement is available from the 
 * DW1000 device. It updates the corresponding anchor with the new range and 
 * address, or adds a new anchor if necessary.
 * 
 * @note This callback function is triggered by the DW1000Ranging library.
 */
void newRange()
{
    DW1000Device *distantDevice = DW1000Ranging.getDistantDevice(); /**< Get the device with the new range. */
    uint16_t address = DW1000Ranging.getDistantDevice()->getShortAddress(); /**< Get the address of the device. */
    float range = DW1000Ranging.getDistantDevice()->getRange(); /**< Get the range measurement. */

    bool found = false; /**< Flag to indicate if the device was found among anchors. */
    
    // Try to update existing anchor with the new range
    for (int i = 0; i < numAnchors; i++)
    {
        anchors[i].distance = range;
        anchors[i].address = address;
        anchors[i].active = true;
        found = true;
        break;
    }

    // If no existing anchor was found, add a new one
    if (!found && numAnchors < 3)
    {
        anchors[numAnchors].distance = range;
        anchors[numAnchors].address = address;
        anchors[numAnchors].active = true;
        numAnchors++;
    }
}

/**
 * @brief Callback function when a new device is discovered.
 * 
 * This function is called when a new device is detected by the tag. It logs 
 * the device's short address.
 * 
 * @param device The new device that was detected.
 * 
 * @note This callback function is triggered by the DW1000Ranging library.
 */
void newDevice(DW1000Device *device)
{
    Serial.print("Device added: ");
    Serial.println(device->getShortAddress(), HEX);
}

/**
 * @brief Callback function when a device becomes inactive.
 * 
 * This function is called when a previously active device is no longer active. 
 * It logs the device's address as deleted.
 * 
 * @param device The device that is now inactive.
 * 
 * @note This callback function is triggered by the DW1000Ranging library.
 */
void inactiveDevice(DW1000Device *device)
{
    Serial.print("Delete inactive device: ");
    Serial.println(device->getShortAddress(), HEX);
}