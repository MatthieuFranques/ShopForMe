#include "uwb_anchor.h"
#include "bluetooth_service.h"
#include "data_handler.h"

void setup()
{
    Serial.begin(115200);

    initAnchor();
    initBluetooth();
}

void loop()
{
    handleAnchorLoop();
    handleBluetoothLoop();
}
