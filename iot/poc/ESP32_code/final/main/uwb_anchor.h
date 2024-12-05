#ifndef UWB_ANCHOR_H
#define UWB_ANCHOR_H

#include <SPI.h>
#include <DW1000Ranging.h>

// SPI and UWB pin configuration
#define ANCHOR_ADDRESS "82:17:5B:D5:A9:9A:E2:9C"
#define SPI_SCK 18
#define SPI_MISO 19
#define SPI_MOSI 23
#define PIN_RST 27
#define PIN_IRQ 34
#define PIN_SS 4

// Anchor constants
const float DISTANCE_OFFSET = 0.7;
const long interval = 3000;

// Tag structure
struct Tag
{
    uint8_t address[8];
    float distance;
    bool active;
};

// Global variables
extern Tag tags[3];
extern int numTags;
extern unsigned long previousMillis;

// Anchor functions
void initAnchor();
void handleAnchorLoop();
void newRange();
void newDevice(DW1000Device *device);
void inactiveDevice(DW1000Device *device);

#endif // UWB_ANCHOR_H
