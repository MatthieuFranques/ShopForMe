/**
* @file tag/main/uwb_tag.h
 * @brief Header file for UWB tag functionalities.
 *
 * This file contains the definitions and function prototypes for handling
 * UWB tag communication using the DW1000 module.
 *
 * @date 03/2025
 */

#ifndef UWB_TAG_H
#define UWB_TAG_H

#include <SPI.h>
#include "DW1000Ranging.h"
#include "DW1000.h"

/**
 * @defgroup SPI_Pins SPI Pin Configuration
 * @brief Definitions for SPI and UWB pin connections.
 * @{
 */
#define SPI_SCK 18  ///< SPI Clock pin
#define SPI_MISO 19 ///< SPI MISO (Master In Slave Out) pin
#define SPI_MOSI 23 ///< SPI MOSI (Master Out Slave In) pin
#define PIN_RST 27  ///< UWB module reset pin
#define PIN_IRQ 34  ///< UWB module interrupt pin
#define PIN_SS 4    ///< UWB module chip select pin
/** @} */

/**
 * @brief Interval for tag update in milliseconds.
 */
const long interval = 200;

/**
 * @struct Anchor
 * @brief Structure representing an anchor in UWB ranging.
 */
struct Anchor
{
    uint16_t address; ///< Unique address of the anchor
    float distance;   ///< Distance measurement to the anchor (in meters)
    bool active;      ///< Status of the anchor (true if active, false otherwise)
};

/**
 * @brief Global array to store detected anchors.
 */
extern Anchor anchors[3];

/**
 * @brief Number of detected anchors.
 */
extern int numAnchors;

/**
 * @brief Timestamp of the last ranging update.
 */
extern unsigned long previousMillis;

// Tag functions
void initTag();
void handleTagLoop();
void newRange();
void newDevice(DW1000Device *device);
void inactiveDevice(DW1000Device *device);

#endif // UWB_TAG_H
