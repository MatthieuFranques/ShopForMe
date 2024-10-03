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

const int MAX_TAGS = 3; // Nombre maximal de tags à suivre
unsigned long previousMillis = 0; // variable pour stocker le temps précédent
const long interval = 1000;       // intervalle pour le log (1 seconde)

// Ajout d'un offset constant de 70 cm
const float DISTANCE_OFFSET = 0.7; // en mètres

// Structures pour stocker les distances des tags
struct Tag {
    uint8_t address[8]; // Utiliser un tableau de 8 octets pour l'adresse longue
    float distance;
    bool active;
};

Tag tags[MAX_TAGS];
int numTags = 0;

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

    // Si une seconde est passée, loguer les distances
    if (currentMillis - previousMillis >= interval) {
        previousMillis = currentMillis; // réinitialiser le temps précédent

        // Loguer les distances pour chaque tag actif
        for (int i = 0; i < numTags; i++) {
            if (tags[i].active) {
                Serial.print("ANCHOR: Range to TAG ");
                printAddress(tags[i].address);
                Serial.print("\t Range: ");
                Serial.print(tags[i].distance);
                Serial.print(" m");
                Serial.println();
            }
        }
    }
}

void newRange() {
    DW1000Device* distantDevice = DW1000Ranging.getDistantDevice();
    uint8_t* address = distantDevice->getByteAddress(); // Utiliser l'adresse longue en tableau d'octets
    float range = distantDevice->getRange();

    // Appliquer l'offset de 70 cm (0.7 m)
    range -= DISTANCE_OFFSET;

    // Vérifier si le tag est déjà dans le tableau
    bool found = false;
    for (int i = 0; i < numTags; i++) {
        if (memcmp(tags[i].address, address, 8) == 0) {
            tags[i].distance = range; // Mettre à jour la distance
            tags[i].active = true; // Marquer le tag comme actif
            found = true;
            break;
        }
    }

    // Ajouter un nouveau tag si pas trouvé
    if (!found && numTags < MAX_TAGS) {
        memcpy(tags[numTags].address, address, 8);
        tags[numTags].distance = range;
        tags[numTags].active = true; // Marquer le tag comme actif
        numTags++;
    }
}

void newDevice(DW1000Device *device) {
    uint8_t* address = device->getByteAddress(); // Utiliser l'adresse longue en tableau d'octets
    bool found = false;
    for (int i = 0; i < numTags; i++) {
        if (memcmp(tags[i].address, address, 8) == 0) {
            found = true;
            break;
        }
    }
    if (!found) {
        Serial.print("ANCHOR: New device added -> ");
        printAddress(address);
    }
}

void inactiveDevice(DW1000Device *device) {
    uint8_t* address = device->getByteAddress(); // Utiliser l'adresse longue en tableau d'octets
    for (int i = 0; i < numTags; i++) {
        if (memcmp(tags[i].address, address, 8) == 0) {
            Serial.print("ANCHOR: Inactive device removed -> ");
            printAddress(address);
            // Retirer le tag du tableau en le marquant comme inactif
            tags[i].active = false;
            break;
        }
    }
}

void printAddress(const uint8_t* address) {
    for (int i = 0; i < 8; i++) {
        if (address[i] < 0x10) Serial.print("0");
        Serial.print(address[i], HEX);
        if (i < 7) Serial.print(":");
    }
}