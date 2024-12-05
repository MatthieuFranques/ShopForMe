import 'dart:async';
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
        flutterBlue.stopScan();
        onDeviceFound(scanResult.device);
      }
    });
  }

// Connect to a found device
  void connectToDevice(BluetoothDevice device, Function(Map<String, dynamic>) onDataReceived) async {
    await device.connect();
    connectedDevice = device;

    device.discoverServices().then((services) {
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.properties.notify) {
            characteristic.setNotifyValue(true);
            dataStream = characteristic.value.asBroadcastStream();

            // Écoute des données envoyées par l'ESP32
            dataStream?.listen((data) async {
              try {
                print("Données reçues (bytes) : $data");

                // Convertir les données reçues en une chaîne de caractères
                String decodedData = utf8.decode(data);
                print("Données reçues (texte) : $decodedData");

                if (decodedData.isNotEmpty) {
                  try {
                    // Si les données sont sous forme de chaînes de nombres séparées par des "/"
                    List<String> values = decodedData.split('/');
                    Map<String, dynamic> parsedData = {};

                    for (int i = 0; i < values.length; i++) {
                      parsedData['Tag $i'] = double.tryParse(values[i]);
                    }

                    print("Données parsées : $parsedData");
                    onDataReceived(parsedData); // Retourner les données traitées à la fonction de rappel
                  } catch (e) {
                    print("Erreur lors du traitement des données : $e");
                  }
                }
              } catch (e) {
                print("Erreur lors du décodage des données : $e");
              }
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
