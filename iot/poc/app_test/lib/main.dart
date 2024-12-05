import 'package:flutter/material.dart';
import 'services/bluetooth_service.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth ESP32 App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BluetoothScreen(), // Home page for Bluetooth
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  BluetoothScanService _bluetoothService = BluetoothScanService();
  List<String> devicesList = [];
  String data = 'No data yet';

  void requestPermissions() async {
    if (await checkPermissions()) {
      // Permissions granted, start the scan
      _bluetoothService.startScan((BluetoothDevice device) {
        setState(() {
          devicesList.add(device.name);
        });

        // Connect to the device and listen for JSON data
        _bluetoothService.connectToDevice(device, (receivedData) {
          setState(() {
            data = receivedData as String; // Updates the data received
          });
        });
      });
    } else {
      // Handle permissions not granted
      print('Permissions not granted');
    }
  }

  Future<bool> checkPermissions() async {
    if (await Permission.bluetoothScan.request().isGranted &&
        await Permission.bluetoothConnect.request().isGranted &&
        await Permission.locationWhenInUse.request().isGranted) {
      // if everything is OK, return true
      return true;
    } else {
      // otherwise, false
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermissions(); // Request permissions at the start
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
      ),
      body: Column(
        children: [
          Expanded(
            child: devicesList.isEmpty
                ? Center(child: Text('Scanning for devices...'))
                : ListView.builder(
              itemCount: devicesList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(devicesList[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Data received: $data'),
          ),
        ],
      ),
    );
  }
}
