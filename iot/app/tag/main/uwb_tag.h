#ifndef UWB_TAG_H
#define UWB_TAG_H

#include <SPI.h>
#include "DW1000Ranging.h"
#include "DW1000.h"

// SPI and UWB pin configuration
#define SPI_SCK 18
#define SPI_MISO 19
#define SPI_MOSI 23
#define PIN_RST 27
#define PIN_IRQ 34
#define PIN_SS 4

// Tag constants
const long interval = 200;

// Anchor structure
struct Anchor
{
    uint16_t address;
    float distance;
    bool active;
};

// Global variables
extern Anchor anchors[3];
extern int numAnchors;
extern unsigned long previousMillis;

// Tag functions
void initTag();
void handleTagLoop();
void newRange();
void newDevice(DW1000Device *device);
void inactiveDevice(DW1000Device *device);

#endif // UWB_TAG_H
