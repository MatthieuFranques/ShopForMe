#ifndef UTILS_H
#define UTILS_H

#include <Arduino.h>

void logDistances(const uint8_t *address, float range);
String getAddress(const uint8_t *address);
void printAddress(const uint8_t *address); // Ajoutez cette déclaration

#endif // UTILS_H
