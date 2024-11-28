import 'dart:convert';

import 'package:flutter_blue/flutter_blue.dart';

class BluetoothScanService {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? characteristic;

  // Stream for device data
  Stream<List<int>>? dataStream;

  // Start scanning for devices
  void startScan(Function(BluetoothDevice) onDeviceFound) {
    flutterBlue.scan().listen((scanResult) {
      if (scanResult.device.name == 'ESP32_BLE') {
        print("On est la l'équipe dans : startScan");
        flutterBlue.stopScan();
        onDeviceFound(scanResult.device);
      }
    });
  }

  // Connect to a found device
  void connectToDevice(
      BluetoothDevice device, Function(String) onDataReceived) async {
    await device.connect();
    connectedDevice = device;
    print(
        "On est la l'équipe dans : connectToDevice   après await device.connect");

    device.discoverServices().then((services) {
      print("On est la l'équipe dans : discoverServices");

      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.properties.notify) {
            characteristic.setNotifyValue(true);
            dataStream = characteristic.value.asBroadcastStream();

            // Listen to the data stream sent by the ESP32
            dataStream?.listen((data) {
              String jsonString = utf8.decode(data); // Decode the data received
              onDataReceived(jsonString);
              print("jsonString : ${jsonString}"); // Send the JSON to the UI
            });
          }
        }
      }
    });
  }

  // Disconnect from device
  void disconnect() {
    connectedDevice?.disconnect();
  }
}
