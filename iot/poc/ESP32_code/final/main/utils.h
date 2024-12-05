#ifndef UTILS_H
#define UTILS_H

#include <Arduino.h>

void logDistances(const uint8_t *address, float range);
String getAddress(const uint8_t *address);

#endif // UTILS_H
