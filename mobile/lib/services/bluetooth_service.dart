import 'dart:async';
import 'dart:convert';

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

  Future<void> getAnchorDistances(
  BluetoothDevice device, {
  required Future<void> Function(String decodedData) onDataReceived,
}) async {
  try {
    // Check if the device is already connected
    final BluetoothDeviceState currentState = await device.state.first;
    
    if (currentState == BluetoothDeviceState.connected) {
      print("Device already connected. Skipping reconnection...");
    } else {
      print("Connecting to device: ${device.name}...");
      
      // Ensure previous connection is fully closed
      await device.disconnect();
      await Future.delayed(const Duration(seconds: 1)); // Allow ESP32 to reset
      
      await device.connect(autoConnect: false);
      print("Connected to device.");
    }

    // Discover services and characteristics
    print("Discovering services...");
    for (final service in await device.discoverServices()) {
      for (final characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          print("Subscribing to notifications: ${characteristic.uuid}");
          await characteristic.setNotifyValue(true);

          // Listen for incoming data
          characteristic.value.listen((data) async {
            try {
              final decodedData = utf8.decode(data);
              print("Data received: $decodedData");
              await onDataReceived(decodedData);
            } catch (e) {
              print("Error decoding data: $e");
            }
          });
        }
      }
    }
  } catch (e) {
    print("Connection error: $e");
    rethrow;
  }
}

  Future<BluetoothDevice> getBluetoothDevice() async {
  print("Starting Bluetooth scan...");

  // Créer une instance de FlutterBlue pour le scan
  final FlutterBlue flutterBlue = FlutterBlue.instance;

  // Ensure any ongoing scan is stopped before starting a new one
  if (await flutterBlue.isScanning.first) {
    print("Stopping previous scan...");
    await flutterBlue.stopScan();
    await Future.delayed(const Duration(seconds: 1)); // Allow cleanup
  }

  // Lancer un scan pour trouver les appareils
  final completer = Completer<BluetoothDevice>();
  late StreamSubscription<ScanResult> scanSubscription;

  // Écouter les résultats du scan
  scanSubscription = flutterBlue.scan().listen((scanResult) async {
    if (scanResult.device.name == 'ESP32_BLE') {
      print("Device found: ${scanResult.device.name}");

      // Arrêter le scan une fois que l'appareil est trouvé
      await flutterBlue.stopScan();
      await scanSubscription.cancel();

      // Retourner le périphérique trouvé
      completer.complete(scanResult.device);
    }
  });

  // Wait for a max of 5 seconds for a device to be found
  await Future.delayed(const Duration(seconds: 5));

  // Si l'appareil n'a pas été trouvé, le scan s'arrête
  if (!completer.isCompleted) {
    await flutterBlue.stopScan();
    await scanSubscription.cancel();
    completer.completeError('Device not found');
  }

  return completer.future;
}

  // Disconnect from device
  void disconnect() {
    connectedDevice?.disconnect();
  }
}


