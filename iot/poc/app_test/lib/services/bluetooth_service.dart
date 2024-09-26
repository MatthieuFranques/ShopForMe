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
  void connectToDevice(BluetoothDevice device) async {
    //TODO
  }

  // Disconnect from device
  void disconnect() {
    connectedDevice?.disconnect();
  }
}
