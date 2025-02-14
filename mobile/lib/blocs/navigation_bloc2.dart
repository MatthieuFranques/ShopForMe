// navigation_bloc2.dart
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobile/blocs/navigation_bloc.dart';
import 'package:mobile/services/location_service.dart';
import 'package:permission_handler/permission_handler.dart';

enum ArrowDirection { nord, sud, est, ouest }

// Events
abstract class NavigationEvent {}

class CheckBluetoothConnection extends NavigationEvent {}

class ListenToESP extends NavigationEvent {}

class CalculateShortestPath extends NavigationEvent {}

// States
abstract class NavigationState {}

class NavigationInitial extends NavigationState {}

class BluetoothConnected extends NavigationState {}

class BluetoothDisconnected extends NavigationState {}

class ListeningToESP extends NavigationState {}

class NavigationLoadedState extends NavigationState {
  final String objectName;
  final String instruction;
  final ArrowDirection arrowDirection;
  final bool isLastProduct;
  final bool isDone;

  NavigationLoadedState({
    required this.objectName,
    required this.instruction,
    required this.arrowDirection,
    this.isLastProduct = false,
    this.isDone = false,
  });
}

// Bloc
class NavigationBloc2 extends Bloc<NavigationEvent, NavigationState> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  StreamSubscription? _bluetoothSubscription;
  late final LocationService _locationService;

  NavigationBloc2() : super(NavigationInitial()) {
    on<CheckBluetoothConnection>(_onCheckBluetoothConnection);
    on<ListenToESP>(_onListenToESP);
    on<CalculateShortestPath>(_onCalculateShortestPath);
  }

  void _onCheckBluetoothConnection(
      CheckBluetoothConnection event, Emitter<NavigationState> emit) async {
    bool isBluetoothOn = await flutterBlue.isOn;
    if (isBluetoothOn) {
      emit(BluetoothConnected());
    } else {
      emit(BluetoothDisconnected());
    }
  }

  void _onListenToESP(ListenToESP event, Emitter<NavigationState> emit) {
    // Simulation de l'écoute d'un ESP
    _bluetoothSubscription = flutterBlue.scan().listen((scanResult) {
      if (scanResult.device.name == "ESP_Target") {
        emit(ListeningToESP());
      }
    });
  }

  void _onCalculateShortestPath(
      CalculateShortestPath event, Emitter<NavigationState> emit) async {
    // Vérifiez d'abord les permissions, car vous pourriez avoir besoin de l'emplacement
    bool hasPermissions = await checkPermissions();
    if (!hasPermissions) {
      // Gérer le cas où les permissions ne sont pas accordées
      return;
    }

    try {
      //TODO Bluetooth conect

      // récupère les dsitances des esp sur une variable
      final Map<String, dynamic> jsonDistanceFile = {
        "Tag 0": 205.0,
        "Tag 1": 214.0,
        "Tag 2": 75.0
      };

      // Appelle la fonction pour mettre à jour jsonDistanceFile
      updateJsonDistanceFile(jsonDistanceFile);
      String jsonString = jsonEncode(jsonDistanceFile);
      // Appelez la fonction findTargetPosition2 pour obtenir le chemin le plus court
      final List<List<int>> shortestPath =
          await _locationService.findTargetPosition2(jsonEncode(jsonString));

      // Vous pouvez convertir shortestPath en une liste de chaînes (ou utiliser directement List<List<int>> si vous préférez)
      List<String> pathString =
          shortestPath.map((point) => "Point ${point[0]},${point[1]}").toList();
      print(" pathString  : $pathString");

      // emit(PathCalculated(pathString));
      if (shortestPath != null && shortestPath.isNotEmpty) {
        final ArrowDirection direction = _calculateDirection(shortestPath);
        final instruction = _generateInstruction(shortestPath);

        emit(NavigationLoadedState(
          objectName: "Pate",
          arrowDirection: direction,
          instruction: instruction,
          isLastProduct: true,
        ));
      }
    } catch (e) {
      // Gérer les erreurs si la fonction échoue
      print("Erreur lors du calcul du chemin le plus court: $e");
    }
  }

  @override
  Future<void> close() {
    _bluetoothSubscription?.cancel();
    return super.close();
  }

  ArrowDirection _calculateDirection(List<List<int>> path) {
    if (path.length < 2) return ArrowDirection.nord;

    final current = path[0];
    final next = path[1];

    if (next[0] < current[0]) return ArrowDirection.nord;
    if (next[0] > current[0]) return ArrowDirection.sud;
    if (next[1] < current[1]) return ArrowDirection.ouest;
    return ArrowDirection.est;
  }

  String _generateInstruction(List<List<int>> path) {
    final distance = path.length - 1;
    final direction = _calculateDirection(path);

    switch (direction) {
      case ArrowDirection.nord:
        return "Orientation à 12H00 , Avancez de $distance pas";
      case ArrowDirection.sud:
        return "Orientation à 6H00 , Avancez de $distance pas";
      case ArrowDirection.est:
        return "Orientation à 3H00 , Avancez de $distance pas";
      case ArrowDirection.ouest:
        return "Orientation à 9H00 , Avancez de $distance pas";
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

  /// Met à jour la map passée en paramètre avec des valeurs aléatoires
  /// générées à partir d'un entier à 4 chiffres divisé par 10.
  void updateJsonDistanceFile(Map<String, dynamic> jsonDistanceFile) {
    final random = Random();
    jsonDistanceFile.updateAll((key, value) {
      // Génère un entier entre 1000 et 9999 (4 chiffres)
      int randomInt = random.nextInt(9000) + 1000;
      // Divise par 10 pour obtenir 1 chiffre après la virgule
      double randomDouble = randomInt / 10;
      return randomDouble;
    });
  }
}
