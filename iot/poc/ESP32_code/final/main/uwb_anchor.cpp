#include "uwb_anchor.h"
#include "utils.h"
#include "data_handler.h"

// Global variables
Tag tags[3];
int numTags = 0;
unsigned long previousMillis = 0;

// Anchor initialization
void initAnchor()
{
    SPI.begin(SPI_SCK, SPI_MISO, SPI_MOSI);
    DW1000Ranging.initCommunication(PIN_RST, PIN_SS, PIN_IRQ);
    DW1000Ranging.attachNewRange(newRange);
    DW1000Ranging.attachNewDevice(newDevice);
    DW1000Ranging.attachInactiveDevice(inactiveDevice);
    DW1000Ranging.startAsAnchor(ANCHOR_ADDRESS, DW1000.MODE_LONGDATA_RANGE_LOWPOWER);
    Serial.println("Anchor initialized and running...");
}

// Anchor loop logic
void handleAnchorLoop()
{
    DW1000Ranging.loop();
    unsigned long currentMillis = millis();

    if (currentMillis - previousMillis >= interval)
    {
        previousMillis = currentMillis;
        for (int i = 0; i < numTags; i++)
        {
            if (tags[i].active)
            {
                logDistances(tags[i].address, tags[i].distance);
                constructPackage(getAddress(tags[i].address), tags[i].distance);
            }
        }
    }
}

// New range detection
void newRange()
{
    DW1000Device *distantDevice = DW1000Ranging.getDistantDevice();
    uint8_t *address = distantDevice->getByteAddress();
    float range = distantDevice->getRange() - DISTANCE_OFFSET;

    bool found = false;
    for (int i = 0; i < numTags; i++)
    {
        if (memcmp(tags[i].address, address, 8) == 0)
        {
            tags[i].distance = range;
            tags[i].active = true;
            found = true;
            break;
        }
    }

    if (!found && numTags < 3)
    {
        memcpy(tags[numTags].address, address, 8);
        tags[numTags].distance = range;
        tags[numTags].active = true;
        numTags++;
    }
}

// New device detected
void newDevice(DW1000Device *device)
{
    uint8_t *address = device->getByteAddress();
    Serial.print("New device detected: ");
    printAddress(address);
    Serial.println();
}

// Inactive device removed
void inactiveDevice(DW1000Device *device)
{
    uint8_t *address = device->getByteAddress();
    for (int i = 0; i < numTags; i++)
    {
        if (memcmp(tags[i].address, address, 8) == 0)
        {
            for (int j = i; j < numTags - 1; j++)
            {
                tags[j] = tags[j + 1];
            }
            numTags--;
            Serial.println("Inactive device removed.");
            break;
        }
    }
}
