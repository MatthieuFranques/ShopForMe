/**
 * @file tag/main/data_handler.h
 * @brief Header file for data handling functions.
 *
 * This file declares the functions used to handle, construct, and send data via Bluetooth.
 * These functions process data collected from various sources and ensure that it is formatted
 * and validated before being sent.
 *
 * @date 03/2025
 */

#ifndef DATA_HANDLER_H
#define DATA_HANDLER_H

#include <Arduino.h>
#include <map>

// Data handling functions
void constructPackage(String address, float range);
void sendData(std::map<String, float> dataToSend);
String constructString(std::map<String, float> dataToSend);

#endif // DATA_HANDLER_H
