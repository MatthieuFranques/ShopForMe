#include <SPI.h>
#include "DW1000Ranging.h"
#include "DW1000.h"

// anchor adress
char ANCHOR_ADDRESS[] = "9E:11:33:BC:72:81:3C:9D";

// calibrated Antenna Delay setting for this anchor
uint16_t Adelay = 16580;

// calibration distance
float dist_m = (285 - 1.75) * 0.0254; //meters

#define SPI_SCK 18
#define SPI_MISO 19
#define SPI_MOSI 23
#define DW_CS 4

const uint8_t PIN_RST = 27; // reset pin
const uint8_t PIN_IRQ = 34; // irq pin
const uint8_t PIN_SS = 4;   // spi select pin

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

void loop() {
    DW1000Ranging.loop();
}

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