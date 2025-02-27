#ifndef UTILS_H
#define UTILS_H

#include <Arduino.h>

void logDistances(const uint16_t address, float range);
String getAddress(const uint16_t address);
void printAddress(const uint16_t address);

#endif // UTILS_H
