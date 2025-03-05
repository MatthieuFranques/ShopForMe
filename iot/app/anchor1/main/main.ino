/**
 * @file anchor1/main.ino
 * @brief Program to initialise an ESP32 as a DW1000 anchor and measure the distance with a tag.
 * 
 * This program configures the ESP32 as a DW1000 anchor and uses the ranging protocol to measure distances.
 * It initializes SPI communication and handles interrupts to retrieve distances from DW1000 tags.
 *
 * @date 03/2025
 */

#include <SPI.h>
#include "DW1000Ranging.h"
#include "DW1000.h"

/// Anchor address
char ANCHOR_ADDRESS[] = "7D:00:22:EA:82:60:3B:9C";

/// Calibrated antenna delay for this anchor
uint16_t Adelay = 16580;

/// Calibration distance in metres
float dist_m = (285 - 1.75) * 0.0254;

/// SPI pins
#define SPI_SCK 18
#define SPI_MISO 19
#define SPI_MOSI 23
#define DW_CS 4

/// Reset pin
const uint8_t PIN_RST = 27;
/// Interrupt pin
const uint8_t PIN_IRQ = 34;
/// SPI selection pin
const uint8_t PIN_SS = 4;

/**
 * @brief Initializes the ESP32 as a DW1000 anchor.
 * 
 * Configures SPI communication and initializes the DW1000Ranging library.
 */
void setup() {
    Serial.begin(115200);
    delay(1000);
    Serial.println("Starting as ANCHOR...");

    SPI.begin(SPI_SCK, SPI_MISO, SPI_MOSI);
    DW1000Ranging.initCommunication(PIN_RST, PIN_SS, PIN_IRQ); // Reset, CS, IRQ pin

    DW1000.setAntennaDelay(Adelay);

    DW1000Ranging.attachNewRange(newRange);

    DW1000Ranging.startAsAnchor(ANCHOR_ADDRESS, DW1000.MODE_LONGDATA_RANGE_LOWPOWER, false);
    Serial.println("ANCHOR initialized and running...");
}

/**
 * @brief Main loop executing the ranging logic.
 * 
 * This function continuously executes the distance measurement logic.
 */
void loop() {
    DW1000Ranging.loop();
}

/**
 * @brief Callback function called when a new distance is measured.
 * 
 * Displays the distance measured between the anchor and a DW1000 tag.
 */
void newRange()
{
    Serial.print(DW1000Ranging.getDistantDevice()->getShortAddress(), HEX);
    Serial.print(", ");

    #define NUMBER_OF_DISTANCES 1
    float dist = 0.0;
    for (int i = 0; i < NUMBER_OF_DISTANCES; i++) {
        dist += DW1000Ranging.getDistantDevice()->getRange();
    }
    dist = dist/NUMBER_OF_DISTANCES;
    Serial.println(dist);
}