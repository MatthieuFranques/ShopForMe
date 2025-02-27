#include "uwb_tag.h"
#include "utils.h"
#include "data_handler.h"

// Global variables
Anchor anchors[3];
int numAnchors = 0;
unsigned long previousMillis = 0;
char TAG_ADDRESS[] = "7D:00:22:EA:82:60:3B:9C";

// Tag initialization
void initTag()
{
    SPI.begin(SPI_SCK, SPI_MISO, SPI_MOSI);
    DW1000Ranging.initCommunication(PIN_RST, PIN_SS, PIN_IRQ);
    DW1000Ranging.attachNewRange(newRange);
    DW1000Ranging.attachNewDevice(newDevice);
    DW1000Ranging.attachInactiveDevice(inactiveDevice);
    DW1000Ranging.startAsTag(TAG_ADDRESS, DW1000.MODE_LONGDATA_RANGE_LOWPOWER, false);
    Serial.println("Tag initialized and running...");
}

// Tag loop logic
void handleTagLoop()
{
    DW1000Ranging.loop();
    unsigned long currentMillis = millis();

    if (currentMillis - previousMillis >= interval)
    {
        previousMillis = currentMillis;
        for (int i = 0; i < numAnchors; i++)
        {
            logDistances(anchors[i].address, anchors[i].distance);
            constructPackage(getAddress(anchors[i].address), anchors[i].distance);
        }
    }
}
void newRange()
{
    DW1000Device *distantDevice = DW1000Ranging.getDistantDevice();
    uint16_t address = DW1000Ranging.getDistantDevice()->getShortAddress();
    float range = DW1000Ranging.getDistantDevice()->getRange();

    bool found = false;
    for (int i = 0; i < numAnchors; i++)
    {
        anchors[i].distance = range;
        anchors[i].address = address;
        anchors[i].active = true;
        found = true;
        break;
    }

    if (!found && numAnchors < 3)
    {
        anchors[numAnchors].distance = range;
        anchors[numAnchors].address = address;
        anchors[numAnchors].active = true;
        numAnchors++;
    }
}

void newDevice(DW1000Device *device)
{
    Serial.print("Device added: ");
    Serial.println(device->getShortAddress(), HEX);
}

void inactiveDevice(DW1000Device *device)
{
    Serial.print("delete inactive device: ");
    Serial.println(device->getShortAddress(), HEX);
}