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
 
  // Stream for device data
  Stream<List<int>>? dataStream;
 
  // Start scanning for devices
  void startScan(Function(BluetoothDevice) onDeviceFound) async {
    flutterBlue.scan().listen((scanResult) {
      if (scanResult.device.name == 'ESP32_BLE') {
        flutterBlue.stopScan();
        onDeviceFound(scanResult.device);
      }
    });
  }
 
  /// Méthode pour se connecter à un périphérique BLE et écouter les données
   
void connectToDevice(SendPort sendPort) async {
  try {
    print("In connectToDevice!!");
    BluetoothDevice device = await startScan2();
    print("enter connectToDevice");
    print("device : ${device.name}");
    while (true){
      sleep(new Duration(seconds: 3));
      sendPort.send("connecToDevice");
      }
    }
  catch (e){
    print("Error connectToDevice!!!");
    print(e);
  }
  //   // Connect to the device
  //   print("Connecting to device: ${device.name}");
  //   await device.connect();
  //   print("after device.connect()");
 
  //   // Discover services and characteristics
  //   print("Discovering services...");
  //   List<BluetoothService> services = await device.discoverServices();
  //   for (var service in services) {
  //     for (var characteristic in service.characteristics) {
  //       // If a characteristic allows notification
  //       if (characteristic.properties.notify) {
  //         print("Characteristic found with notifications: ${characteristic.uuid}");
  //         await characteristic.setNotifyValue(true);
  //         Stream<List<int>> dataStream = characteristic.value.asBroadcastStream();
 
  //         // Listen to data sent by the ESP32
  //         dataStream.listen((data) async {
  //           try {
  //             print("Data received (bytes): $data");
 
  //             // Decode the received data to text
  //             String decodedData = utf8.decode(data);
  //             print("Data received (text): $decodedData");
  //             sendPort.send(decodedData);
 
  //             if (decodedData.isNotEmpty) {
  //               try {
  //                 // Process data as numbers separated by "/"
  //                 List<String> values = decodedData.split('/');
  //                 Map<String, dynamic> parsedData = {};
 
  //                 for (int i = 0; i < values.length; i++) {
  //                   parsedData['Tag $i'] = double.tryParse(values[i]);
  //                 }
 
  //                 print("Parsed data: $parsedData");
  //               } catch (e) {
  //                 print("Error processing data: $e");
  //               }
  //             }
  //           } catch (e) {
  //             print("Error decoding data: $e");
  //           }
  //         });
  //       }
  //     }
  //   }
  // } catch (e) {
  //   print("Error connecting to device: $e");
  // }
}
 
  Future<String> connectToDeviceString(BluetoothDevice device) async {
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
            await for (var data in dataStream!) {
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
 
                    // Retourner les données traitées sous forme de chaîne
                    return jsonEncode(
                        parsedData); // Vous pouvez modifier ici pour renvoyer une chaîne spécifique
                  } catch (e) {
                    print("Erreur lors du traitement des données : $e");
                    return "Erreur lors du traitement des données.";
                  }
                } else {
                  connectToDeviceString(device);
                  return "Aucune donnée reçue";
                }
              } catch (e) {
                print("Erreur lors du décodage des données : $e");
                return "Erreur lors du décodage des données.";
              }
            }
          }
        }
      }
      return "Aucune caractéristique avec notifications trouvée.";
    } catch (e) {
      print("Erreur lors de la connexion : $e");
      return "Erreur lors de la connexion : $e";
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