import 'package:flutter/material.dart';
import 'services/bluetooth_service.dart';
import 'package:flutter_blue/flutter_blue.dart';

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

  @override
  void initState() {
    super.initState();
    _bluetoothService.startScan((BluetoothDevice device) {
      setState(() {
        devicesList.add(device.name);
      });
      _bluetoothService.connectToDevice(device);
    });

    _bluetoothService.dataStream?.listen((value) {
      setState(() {
        data = String.fromCharCodes(value);
      });
    });
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
