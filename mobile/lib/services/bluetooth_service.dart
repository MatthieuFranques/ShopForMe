import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue/flutter_blue.dart';

class BluetoothScanService {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? characteristic;

  // Création d'un StreamController pour gérer les données
  final _dataController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get dataStream => _dataController.stream;

  Future<void> startScanAndConnect() async {
    print("Début du scan Bluetooth");

    try {
      await flutterBlue.scan().firstWhere((scanResult) {
        return scanResult.device.name == 'ESP32_BLE';
      }).then((scanResult) async {
        print("Appareil ESP32_BLE trouvé");
        await flutterBlue.stopScan();
        await _connectToDevice(scanResult.device);
      });
    } catch (e) {
      print("Erreur lors du scan : $e");
      _dataController.addError(e);
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      print("Connexion au périphérique : ${device.name}");
      await device.connect();
      connectedDevice = device;

      print("Découverte des services...");
      final services = await device.discoverServices();

      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.properties.notify) {
            print(
                "Caractéristique avec notifications trouvée : ${characteristic.uuid}");
            await characteristic.setNotifyValue(true);

            characteristic.value.listen((data) {
              _processData(data);
            }, onError: (error) {
              print("Erreur de réception des données : $error");
              _dataController.addError(error);
            });
          }
        }
      }
    } catch (e) {
      print("Erreur de connexion : $e");
      _dataController.addError(e);
    }
  }

  void _processData(List<int> data) {
    try {
      final decodedData = utf8.decode(data);
      print("Données décodées : $decodedData");

      if (decodedData.isNotEmpty) {
        final values = decodedData.split('/');
        final parsedData = <String, dynamic>{};

        for (int i = 0; i < values.length; i++) {
          parsedData['Tag $i'] = double.tryParse(values[i]);
        }

        print("Données traitées : $parsedData");
        _dataController.add(parsedData);
      }
    } catch (e) {
      print("Erreur de traitement des données : $e");
      _dataController.addError(e);
    }
  }

  Future<void> disconnect() async {
    try {
      await connectedDevice?.disconnect();
      await _dataController.close();
    } catch (e) {
      print("Erreur lors de la déconnexion : $e");
    }
  }

  void dispose() {
    disconnect();
  }
}
