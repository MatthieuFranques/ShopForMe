import 'dart:async';
import 'dart:convert';
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
  // Future<void> _onLoadNavigation(
  //   LoadNavigationEvent event,
  //   Emitter<NavigationState> emit,
  // ) async {
  //   try {
  //     // Vérifier les permissions
  //     final bool permission = await checkPermissions();
  //     if (!permission) {
  //       throw Exception("Permissions not granted.");
  //     }
  //     // TODO
  //     // Cache init
  //     if (_cachedGrid == null) {
  //       print("Chargement du PLAN depuis $jsonFilePath");
  //       _cachedGrid = await _locationService.loadGridFromJson(jsonFilePath);
  //     }
  //     _cacheBeaconPositions ??=
  //         await _locationService.getBeaconPositions(jsonFilePath);

  //     _cacheProductPosition ??=
  //         await _locationService.getProductPosition(jsonFilePath);
  //     print("Starting Bluetooth scan...");

  //     _navigationTimer =
  //         Timer.periodic(const Duration(milliseconds: 2000), (timer) {
  //       // Valeurs de base
  //       final List<double> baseValues = [100, 100, 100];
  //       final random = Random();

  //       // Pour chaque valeur, ajouter une variation aléatoire entre -5 et +5
  //       final List<String> newValues = baseValues.map((base) {
  //         double variation =
  //             random.nextDouble() * 10 - 5; // variation entre -5 et +5
  //         double newValue = base + variation;
  //         return newValue.toStringAsFixed(1); // 1 chiffre après la virgule
  //       }).toList();

  //       // Decode data row
  //       String decodedData = newValues.join("/");
  //       // Call the emit to update with _onUpdateNavigation
  //       add(UpdateNavigationEventDataRow(decodedData));
  //     });
  //   } catch (e) {
  //     print("Error: $e");
  //     if (!emit.isDone) {
  //       emit(NavigationError(e.toString()));
  //     }
  //   }
  // }

  // TODO _onLoadNavigation with blu
  Future<void> _onLoadNavigation(
    LoadNavigationEvent event,
    Emitter<NavigationState> emit,
  )
  async {
    try {
      // TODO
      await checkPermissions();
      _cachedGrid == null ? _cachedGrid = await _locationService.loadGridFromJson(jsonFilePath) : null;
      final device = await _bluetoothService.startScan();
      device == null ? throw Exception("No device found!") : null;
      
      await _bluetoothService.connectToDevice(device,
          onDataReceived: (String decodedData) async {
        print("decodedData : $decodedData");
        if (decodedData != "") {
          print(" if (decodedData != " ") {");
          add(UpdateNavigationEventDataRow(decodedData));
        }
      });
    } catch (e) {
      print("Error: $e");
      if (!emit.isDone) {
        emit(NavigationError(e.toString()));
      }
    }
  }

  /// Update of navigation change state of arow and position user
  void _onUpdateNavigation(
    UpdateNavigationEventDataRow event,
    Emitter<NavigationState> emit,
  ) async {
    final anchorDistances = event.decodedData.split("/");
    final List<List<int>>? shortestPath =
        await _locationService.getShortestPath(anchorDistances, _cachedGrid!);
    print("shortestPath : $shortestPath");
    if (!const DeepCollectionEquality().equals(shortestPath, null
    )) {
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

  String _generateInstruction(List<List<int>> path) {
    // TODO a changer mais garder cette logique pour la fin de la navigation (l'arriver vers le produit)
    // exemple si distance = 1 alors on concidère qu'on est arriver.
    final distance = path.length - 1;
    final direction = _calculateDirection(path);

    switch (direction) {
      case ArrowDirection.nord:
        return " 12H00 , Avancez de $distance pas";
      case ArrowDirection.sud:
        return "6H00 , Avancez de $distance pas";
      case ArrowDirection.est:
        return " 3H00 , Avancez de $distance pas";
      case ArrowDirection.ouest:
        return " 9H00 , Avancez de $distance pas";
    }
  }

  Future<void> checkPermissions() async {
    if (!await Permission.bluetoothScan.request().isGranted ||
        !await Permission.bluetoothConnect.request().isGranted ||
        !await Permission.locationWhenInUse.request().isGranted) {
          throw Exception("Permissions not granted.");
    }
  }
}