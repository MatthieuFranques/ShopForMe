#include "BluetoothSerial.h"

// Check if Bluetooth and Bluedroid (Bluetooth stack for ESP32) are enabled
#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to enable it
#endif

BluetoothSerial SerialBT;

void setup() {
  Serial.begin(115200);
  SerialBT.begin("ESP32test");  // Start Bluetooth Serial with the device name "ESP32test"
  Serial.println("The device started, now you can pair it with bluetooth!");  // Print a message to the Serial Monitor
}

void loop() {
  // Check if data is available on the hardware serial
  if (Serial.available()) {
    SerialBT.write(Serial.read());
  }
  // Check if data is available on the Bluetooth Serial
  if (SerialBT.available()) {
    Serial.write(SerialBT.read());
  }

  delay(20);  // Delay to prevent excessive CPU usage
}
