/**
 * @file tag/main/utils.h
 * @brief Header file for utility functions related to logging and handling addresses.
 *
 * This header file declares utility functions for logging distances to the anchor,
 * formatting addresses as strings, and printing addresses in a formatted hexadecimal
 * representation.
 *
 * @date 03/2025
 */
#ifndef UTILS_H
#define UTILS_H

#include <Arduino.h>

void logDistances(const uint16_t address, float range);
String getAddress(const uint16_t address);
void printAddress(const uint16_t address);

#endif // UTILS_H