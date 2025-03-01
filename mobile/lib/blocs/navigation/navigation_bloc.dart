import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/models/grid.dart';
import 'package:mobile/services/bluetooth_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/services/store_service.dart';
import 'package:mobile/services/location_service.dart';
import 'package:mobile/services/location_product_service.dart';
import './navigation_event.dart';
import './navigation_state.dart';

Timer? _navigationTimer;

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final StoreService _storeService;
  late final LocationService _locationService;
  late final LocationProductService _locationProductService;
  late final BluetoothScanService _bluetoothService = BluetoothScanService();
  late StreamController<String> _dataController;

  // TODO change to true value
  Grid? _cachedGrid;
  List<int>? _cacheProductPosition;
  List<List<int>>? _cachePath;
  List<int>? _cacheCurrentPosition;

  // const String jsonFilePath = 'assets/demo/plan_test.json';
  String jsonFilePath = 'assets/demo/plan28_11_24.json';

  Timer? _navigationUpdateTimer;
  List<Product> _products = [];
  int _currentProductIndex = 0;

  NavigationBloc(this._storeService) : super(NavigationInitial()) {
    _locationService = LocationService();
    _locationProductService = LocationProductService(_storeService);

    on<LoadNavigationEvent>(_onLoadNavigation);
    // on<UpdateNavigationEvent>(_onUpdateNavigation);
    on<UpdateNavigationEventDataRow>(_onUpdateNavigation);

    on<ProductFoundEvent>(_onProductFound);
    on<UpdatePositionEvent>(_onUpdatePosition);
  }

  @override
  Future<void> close() {
    print("Enter in 'Close' : navigation_bloc");
    _navigationUpdateTimer?.cancel();
    _navigationTimer?.cancel();
    return super.close();
  }

  void _startNavigationUpdates(Product product) {
    _navigationUpdateTimer?.cancel();
    _navigationUpdateTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => add(UpdatePositionEvent(product)),
    );
  }

  // TODO _onLoadNavigation with no blu (test)
  Future<void> _onLoadNavigation(
    LoadNavigationEvent event,
    Emitter<NavigationState> emit,
  ) async {
    try {
      // TODO
      // Cache init
      if (_cachedGrid == null) {
        print("Chargement du PLAN depuis $jsonFilePath");
        _cachedGrid = await _locationService.loadGridFromJson(jsonFilePath);
      }

      _navigationTimer =
          Timer.periodic(const Duration(milliseconds: 1000), (timer) {
        // Valeurs de base
        final List<double> baseValues = [400, 100, 200];
        final random = Random();

        // Pour chaque valeur, ajouter une variation aléatoire entre -5 et +5
        final List<String> newValues = baseValues.map((base) {
          double variation =
              random.nextDouble() * 200 - 50; // variation entre -5 et +5
          double newValue = base + variation;
          return newValue.toStringAsFixed(1); // 1 chiffre après la virgule
        }).toList();

        // Decode data row
        String decodedData = newValues.join("/");
        // Call the emit to update with _onUpdateNavigation
        add(UpdateNavigationEventDataRow(decodedData));
      });
    } catch (e) {
      print("Error: $e");
      if (!emit.isDone) {
        emit(NavigationError(e.toString()));
      }
    }
  }

  // TODO _onLoadNavigation with blu
  // Future<void> _onLoadNavigation(
  //   LoadNavigationEvent event,
  //   Emitter<NavigationState> emit,
  // )
  // async {
  //   try {
  //     // TODO
  //     await checkPermissions();
  //     _cachedGrid == null ? _cachedGrid = await _locationService.loadGridFromJson(jsonFilePath) : null;
  //     final device = await _bluetoothService.startScan();
  //     device == null ? throw Exception("No device found!") : null;

  //     await _bluetoothService.connectToDevice(device,
  //         onDataReceived: (String decodedData) async {
  //       print("decodedData : $decodedData");
  //       if (decodedData != "") {
  //         print(" if (decodedData != " ") {");
  //         add(UpdateNavigationEventDataRow(decodedData));
  //       }
  //     });
  //   } catch (e) {
  //     print("Error: $e");
  //     if (!emit.isDone) {
  //       emit(NavigationError(e.toString()));
  //     }
  //   }
  // }

  /// Update of navigation change state of arow and position user
  void _onUpdateNavigation(
    UpdateNavigationEventDataRow event,
    Emitter<NavigationState> emit,
  ) async {
    final anchorDistances = event.decodedData.split("/");
    final List<List<int>>? shortestPath =
        await _locationService.getShortestPath(anchorDistances, _cachedGrid!);
    print("shortestPath : $shortestPath");
    if (!const DeepCollectionEquality().equals(shortestPath, null)) {
      emit(NavigationLoadedState(
        objectName: "Riz",
        instruction: _generateInstruction(shortestPath!),
        arrowDirection: _calculateDirection(shortestPath),
        isLastProduct: false,
        isDone: false,
      ));
    } else {
      print("Error : null on the navigation");
    }
  }

  /// ENd of Navigation
  Future<void> _onProductFound(
    ProductFoundEvent event,
    Emitter<NavigationState> emit,
  ) async {
    _navigationUpdateTimer?.cancel();
    try {
      _currentProductIndex++;

      if (_currentProductIndex >= _products.length) {
        emit(NavigationLoadedState(
          objectName: "Terminé !",
          instruction: "Tous les produits ont été trouvés",
          arrowDirection: ArrowDirection.nord,
          isLastProduct: true,
        ));
        close();
        return;
      }

      await _updateNavigation(_products[_currentProductIndex], emit);
      _startNavigationUpdates(_products[_currentProductIndex]);
    } catch (e) {
      emit(NavigationError(e.toString()));
    }
  }

  Future<void> _onUpdatePosition(
    UpdatePositionEvent event,
    Emitter<NavigationState> emit,
  ) async {
    try {
      await _updateNavigation(event.currentProduct, emit);
    } catch (e) {
      emit(NavigationError(e.toString()));
    }
  }

  //  Change status of arrow
  Future<void> _updateNavigation(
      Product product, Emitter<NavigationState> emit) async {
    final productPosition =
        await _locationProductService.getProductPosition(product);
    final currentPath = null;
    //await _locationService.findTargetPosition(productPosition);

    if (currentPath != null && currentPath.isNotEmpty) {
      final direction = _calculateDirection(currentPath);
      final instruction = _generateInstruction(currentPath);

      emit(NavigationLoadedState(
        objectName: product.name,
        arrowDirection: direction,
        instruction: instruction,
        isLastProduct: _currentProductIndex == _products.length - 1,
      ));
    } else {
      emit(NavigationError("Impossible de trouver un chemin vers le produit"));
    }
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

  Future<void> checkPermissions() async {
    if (!await Permission.bluetoothScan.request().isGranted ||
        !await Permission.bluetoothConnect.request().isGranted ||
        !await Permission.locationWhenInUse.request().isGranted) {
      throw Exception("Permissions not granted.");
    }
  }

  String _generateInstruction(List<List<int>> path) {
    if (path.isEmpty || _cacheCurrentPosition == null) {
      return "Aucune instruction disponible";
    }
    List<List<int>> fullPath = [_cacheCurrentPosition!, ...path];

    // Déterminer la direction initiale
    ArrowDirection initialDirection = _calculateDirection(fullPath);
    int distance = 0;

    // Parcourir le chemin jusqu'au premier changement de direction
    for (int i = 0; i < fullPath.length - 1; i++) {
      final nextDirection = _calculateDirection([fullPath[i], fullPath[i + 1]]);

      if (nextDirection == initialDirection) {
        distance++;
      } else {
        break;
      }
    }
    print("distance : $distance");
    switch (initialDirection) {
      case ArrowDirection.nord:
        return "12H00, Avancez de $distance pas";
      case ArrowDirection.sud:
        return "6H00, Avancez de $distance pas";
      case ArrowDirection.est:
        return "3H00, Avancez de $distance pas";
      case ArrowDirection.ouest:
        return "9H00, Avancez de $distance pas";
      default:
        return "Direction inconnue";
    }
  }

  ///Update the _cacheCurrentPosition
  ///@param : String ESP response distance
  Future<void> updatePosition(List<String> anchorDistances) async {
    // Toujours recalculer la position actuelle avec la triangulation
    _cacheCurrentPosition = await _locationService.getCurrentPosition(
        anchorDistances, _cachedGrid!);

    if (_cachePath == null || _cachePath!.isEmpty) {
      print("Si aucun chemin n'est défini, recalculer le chemin initial");
      await recalculatePath();
      return;
    }
    if (!isPositionNearPath(_cacheCurrentPosition!, _cachePath!)) {
      print("Utilisateur hors chemin, recalcul du plus court chemin...");
      await recalculatePath();
    }
  }

  ///Check if the user is still on the right path with a margin of ±1
  ///@param : currentPosition
  ///@param : path
  bool isPositionNearPath(List<int> currentPosition, List<List<int>> path) {
    for (var step in path) {
      if ((currentPosition[0] - step[0]).abs() <= 1 &&
          (currentPosition[1] - step[1]).abs() <= 1) {
        print("L'utilisateur est encore proche du chemin prévu");
        return true;
      }
    }
    print("L'utilisateur s'est trop éloigné");
    return false;
  }

  ///Reload the Path
  ///Update the _cachePath & _cacheCurrentPosition
  Future<void> recalculatePath(List<String> anchorDistances) async {
    _cachePath = await _locationService.getShortestPath(
      anchorDistances,
      _cachedGrid!,
    );
    if (_cachePath != null && _cachePath!.isNotEmpty) {
      print("Nouvelle currentPosition calculer");
      _cacheCurrentPosition = _cachePath![0];
    }
  }
}
