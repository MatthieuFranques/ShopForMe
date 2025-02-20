#include "uwb_tag.h"
#include "utils.h"
#include "data_handler.h"

// Global variables
Anchor anchors[3];
int numAnchors = 0;
unsigned long previousMillis = 0;

// Tag initialization
void initTag()
{
    SPI.begin(SPI_SCK, SPI_MISO, SPI_MOSI);
    DW1000Ranging.initCommunication(PIN_RST, PIN_SS, PIN_IRQ);
    DW1000Ranging.attachNewRange(newRange);
    DW1000Ranging.attachNewDevice(newDevice);
    DW1000Ranging.attachInactiveDevice(inactiveDevice);
    DW1000Ranging.startAsTag(TAG_ADDRESS, DW1000.MODE_LONGDATA_RANGE_LOWPOWER);
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
            if (anchors[i].active)
            {
                logDistances(anchors[i].address, anchors[i].distance);
                constructPackage(getAddress(anchors[i].address), anchors[i].distance);
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
    for (int i = 0; i < numAnchors; i++)
    {
        if (memcmp(anchors[i].address, address, 8) == 0)
        {
            anchors[i].distance = range;
            anchors[i].active = true;
            found = true;
            break;
        }
    }

    if (!found && numAnchors < 3)
    {
        memcpy(anchors[numAnchors].address, address, 8);
        anchors[numAnchors].distance = range;
        anchors[numAnchors].active = true;
        numAnchors++;
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
    for (int i = 0; i < numAnchors; i++)
    {
        if (memcmp(anchors[i].address, address, 8) == 0)
        {
            for (int j = i; j < numAnchors - 1; j++)
            {
                anchors[j] = anchors[j + 1];
            }
            numAnchors--;
            Serial.println("Inactive device removed.");
            break;
        }
    }
}
