#include "uwb_tag.h"
#include "bluetooth_service.h"
#include "data_handler.h"

void setup()
{
    Serial.begin(115200);

    initTag();
    initBluetooth();
}

void loop()
{
    handleTagLoop();
    handleBluetoothLoop();
}
