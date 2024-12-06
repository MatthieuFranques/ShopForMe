import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
 
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobile/services/shared_service.dart';
 
class BluetoothScanService {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? characteristic;
  late SharedService sharedService;
  final _dataController = StreamController<Map<String, dynamic>>.broadcast();
 
  // Stream for device data
  Stream<List<int>>? dataStream;
 
  // // Start scanning for devices
  // void startScan(Function(BluetoothDevice) onDeviceFound) async {
  //   flutterBlue.scan().listen((scanResult) {
  //     if (scanResult.device.name == 'ESP32_BLE') {
  //       flutterBlue.stopScan();
  //       onDeviceFound(scanResult.device);
  //     }
  //   });
  // }
 
  /// Méthode pour se connecter à un périphérique BLE et écouter les données
   
Future<void> connectToDevice(
  BluetoothDevice device, {
  required Future<void> Function(String decodedData) onDataReceived,
}) async {
  try {
    print("Connecting to device: ${device.name}");
    await device.disconnect();
    await device.connect();
    print("Connected to device.");

    // Discover services and characteristics
    print("Discovering services...");
    final services = await device.discoverServices();
    for (final service in services) {
      for (final characteristic in service.characteristics) {
        // If a characteristic allows notification
        if (characteristic.properties.notify) {
          print("Characteristic with notifications found: ${characteristic.uuid}");
          await characteristic.setNotifyValue(true);

          // Listen for data
          characteristic.value.listen((data) async {
            try {
              final decodedData = utf8.decode(data);
              print("Data received: $decodedData");
              await onDataReceived(decodedData); // Ensure this callback is awaited
            } catch (e) {
              print("Error decoding data: $e");
            }
          });
        }
      }
    }
  } catch (e) {
    print("Error connecting to device: $e");
    rethrow; // Allow the caller to handle the error
  }
}

 /// Traite les données reçues du périphérique Bluetooth
 void _processData(List<int> data) {
    try {
      final decodedData = utf8.decode(data);
      print("Données décodées : $decodedData");

      if (decodedData.isNotEmpty) {
        final values = decodedData.split('/');
        final parsedData = <String, dynamic>{};

        // Construction du map de données
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

 
  Future<BluetoothDevice> startScan2() async {
    print("startScan2 FUTURE");
    // Créez une instance de FlutterBlue pour le scan
    FlutterBlue flutterBlue = FlutterBlue.instance;
    print("startScan2 flutterBlue");
 
    // Lancez un scan pour trouver les appareils
    final completer = Completer<BluetoothDevice>(); // Création du Completer
    print("startScan2 completer");

  if (await flutterBlue.isScanning.first) {
    await flutterBlue.stopScan();
  }
 
    // Écoutez les résultats du scan
    var scanSubscription = flutterBlue.scan().listen((scanResult) {
      print("startScan2 scanSubscription");
      // Lorsque le périphérique souhaité est trouvé
      if (scanResult.device.name == 'ESP32_BLE') {
        // Arrêtez le scan une fois que l'appareil est trouvé
        flutterBlue.stopScan();
 
        // Retournez le périphérique trouvé
        completer.complete(scanResult
            .device); // Complétez le Future avec le périphérique trouvé
      }
    });
 
    // Si le scan prend trop de temps sans trouver l'appareil, on peut gérer un timeout
    await Future.delayed(const Duration(seconds: 10));
 
    // Si l'appareil n'a pas été trouvé, on annule le scan
    if (!completer.isCompleted) {
      flutterBlue.stopScan();
      completer.completeError(
          'Device not found'); // Retourner une erreur si le périphérique n'est pas trouvé
    }
 
    // Attendez et retournez le périphérique trouvé
    return completer.future;
  }
 
  // Disconnect from device
  void disconnect() {
    connectedDevice?.disconnect();
  }
}