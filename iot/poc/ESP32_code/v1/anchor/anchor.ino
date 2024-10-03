#include <SPI.h>
#include "DW1000Ranging.h"

#define ANCHOR_ADDRESS "82:17:5B:D5:A9:9A:E2:9C"
#define SPI_SCK 18
#define SPI_MISO 19
#define SPI_MOSI 23
#define DW_CS 4

const uint8_t PIN_RST = 27; // reset pin
const uint8_t PIN_IRQ = 34; // irq pin
const uint8_t PIN_SS = 4;   // spi select pin

unsigned long previousMillis = 0; // variable pour stocker le temps précédent
const long interval = 1000;       // intervalle pour le log (1 seconde)

void setup() {
    Serial.begin(115200);
    delay(1000);
    Serial.println("Starting as ANCHOR...");

    SPI.begin(SPI_SCK, SPI_MISO, SPI_MOSI);
    DW1000Ranging.initCommunication(PIN_RST, PIN_SS, PIN_IRQ); // Reset, CS, IRQ pin
    DW1000Ranging.attachNewRange(newRange);
    DW1000Ranging.attachNewDevice(newDevice);
    DW1000Ranging.attachInactiveDevice(inactiveDevice);

    DW1000Ranging.startAsAnchor(ANCHOR_ADDRESS, DW1000.MODE_LONGDATA_RANGE_LOWPOWER);
    Serial.println("ANCHOR initialized and running...");
}

void loop() {
    DW1000Ranging.loop();

    unsigned long currentMillis = millis();

    // Si une seconde est passée, loguer la distance
    if (currentMillis - previousMillis >= interval) {
        previousMillis = currentMillis; // réinitialiser le temps précédent

        // Afficher la distance et la puissance du signal
        if (DW1000Ranging.getDistantDevice() != nullptr) {
            Serial.print("ANCHOR: Range to TAG: ");
            Serial.print(DW1000Ranging.getDistantDevice()->getShortAddress(), HEX);
            Serial.print("\t Range: ");
            Serial.print(DW1000Ranging.getDistantDevice()->getRange());
            Serial.print(" m");
            Serial.print("\t RX power: ");
            Serial.print(DW1000Ranging.getDistantDevice()->getRXPower());
            Serial.println(" dBm");
        }
    }
}

void newRange() {
    // Ne rien faire ici pour éviter de loguer trop fréquemment
}

void newDevice(DW1000Device *device) {
    Serial.print("ANCHOR: New device added -> ");
    Serial.print(" short:");
    Serial.println(device->getShortAddress(), HEX);
}

void inactiveDevice(DW1000Device *device) {
    Serial.print("ANCHOR: Inactive device removed -> ");
    Serial.println(device->getShortAddress(), HEX);
}
