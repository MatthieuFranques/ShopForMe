import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobile/services/shared_service.dart';

class BluetoothScanService {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? characteristic;
  late SharedService sharedService;

  // Stream for device data
  Stream<List<int>>? dataStream;

  /// Connects to a Bluetooth device and listens for incoming data, handling connection and service discovery.
  /// 
  /// This function connects to a Bluetooth device if it is not already connected, subscribes to notifications for
  /// characteristics that support it, and processes the received data via the provided callback.
  /// 
  /// ### Parameters:
  /// - `device`: The Bluetooth device to connect to.
  /// - `onDataReceived`: A callback function that will be triggered when data is received from the device. The
  ///   function will be passed the decoded data as a string.
  /// 
  /// ### Throws:
  /// - Throws a [BluetoothDeviceState] error if the connection or subscription fails.
  /// 
  /// ### Example:
  /// ```dart
  /// await getAnchorDistances(device, onDataReceived: (decodedData) {
  ///   print("Decoded data: $decodedData");
  /// });
  /// ```
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

  /// Scans for Bluetooth devices and returns the first device with the name 'ESP32_BLE'.
  /// 
  /// This function starts a Bluetooth scan, looks for devices with the name 'ESP32_BLE', and returns the first
  /// matching device. The scan is automatically stopped once the device is found.
  /// 
  /// ### Returns:
  /// A [BluetoothDevice] representing the found device.
  /// 
  /// ### Throws:
  /// - If no device is found within 5 seconds, an error is returned stating 'Device not found'.
  /// 
  /// ### Example:
  /// ```dart
  /// BluetoothDevice device = await getBluetoothDevice();
  /// print("Found device: ${device.name}");
  /// ```
  Future<BluetoothDevice> getBluetoothDevice() async {
  // coverage:ignore-start
  print("Starting Bluetooth scan...");
  // coverage:ignore-end

    // final bluetoothIsOn = await FlutterBlue.instance.isOn;
    // if (!bluetoothIsOn) {
    //   print("Bluetooth is OFF");
    //   // Prompt the user
    //   return null;
    // }

    // // Check permissions
    // if (Platform.isAndroid) {
    //   final status = await Permission.bluetoothScan.status;
    //   if (!status.isGranted) {
    //     await Permission.bluetoothScan.request();
    //   }
    // }

  // Créer une instance de FlutterBlue pour le scan
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  // coverage:ignore-start
  print("Instance created");
  // coverage:ignore-end

  // Ensure any ongoing scan is stopped before starting a new one
  if (await flutterBlue.isScanning.first) {
    // coverage:ignore-start
    print("Stopping previous scan...");
    // coverage:ignore-end
    await flutterBlue.stopScan();
    await Future.delayed(const Duration(seconds: 1)); // Allow cleanup
  }

  // Lancer un scan pour trouver les appareils
  final completer = Completer<BluetoothDevice>();
  late StreamSubscription<ScanResult> scanSubscription;

  // coverage:ignore-start
  print("Before listening");
  // coverage:ignore-end

  

  // Écouter les résultats du scan
  scanSubscription = flutterBlue.scan().listen((scanResult) async {
    // coverage:ignore-start
    print("Trying to find devices");
    // coverage:ignore-end
    if (scanResult.device.name == 'ESP32_BLE') {
      // coverage:ignore-start
      print("Device found: ${scanResult.device.name}");
      // coverage:ignore-end

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


