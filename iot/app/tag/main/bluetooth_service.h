/**
 * @file tag/main/bluetooth_service.h
 * @brief Header file for Bluetooth service implementation.
 *
 * This header file declares the functions used to initialize and manage
 * Bluetooth Low Energy (BLE) communication for the ESP32, including the
 * initialization of the BLE server and handling of the Bluetooth loop.
 *
 * @date 03/2025
 */

#ifndef BLUETOOTH_SERVICE_H
#define BLUETOOTH_SERVICE_H

void initBluetooth();
void handleBluetoothLoop();

#endif // BLUETOOTH_SERVICE_H