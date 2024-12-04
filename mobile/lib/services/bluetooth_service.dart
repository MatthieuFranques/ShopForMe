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

  /// Méthode pour se connecter à un périphérique BLE et écouter les données
  void connectToDevice(BluetoothDevice device,
      Function(Map<String, dynamic>) onDataReceived) async {
    try {
      // Connexion au périphérique
      print("Connexion au périphérique : ${device.name}");
      await device.connect();
      connectedDevice = device;

      // Découverte des services et caractéristiques
      print("Découverte des services...");
      List<BluetoothService> services = await device.discoverServices();
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          // Si une caractéristique permet la notification
          if (characteristic.properties.notify) {
            print(
                "Caractéristique trouvée avec notifications : ${characteristic.uuid}");
            await characteristic.setNotifyValue(true);
            dataStream = characteristic.value.asBroadcastStream();

            // Écoute des données envoyées par l'ESP32
            dataStream?.listen((data) async {
              try {
                print("Données reçues (bytes) : $data");

                // Décodage des données reçues en texte
                String decodedData = utf8.decode(data);
                print("Données reçues (texte) : $decodedData");

                if (decodedData.isNotEmpty) {
                  try {
                    // Traitement des données sous forme de nombres séparés par "/"
                    List<String> values = decodedData.split('/');
                    Map<String, dynamic> parsedData = {};

                    for (int i = 0; i < values.length; i++) {
                      parsedData['Tag $i'] = double.tryParse(values[i]);
                    }

                    print("Données parsées : $parsedData");
                    onDataReceived(
                        parsedData); // Retourner les données traitées
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
    } catch (e) {
      print("Erreur lors de la connexion : $e");
    }
  }

  // Disconnect from device
  void disconnect() {
    connectedDevice?.disconnect();
  }
}
