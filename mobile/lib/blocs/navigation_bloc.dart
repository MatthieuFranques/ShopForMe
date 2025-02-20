import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobile/models/grid.dart';
import 'package:mobile/services/bluetooth_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/product.dart';
import '../services/store_service.dart';
import '../services/location_service.dart';
import '../services/location_product_service.dart';

enum ArrowDirection { nord, sud, est, ouest }

Timer? _navigationTimer;

// Events
abstract class NavigationEvent {}

class LoadNavigationEvent extends NavigationEvent {
  final List<Product> products;
  LoadNavigationEvent({required this.products});
}

class UpdateNavigationEvent extends NavigationEvent {
  final Product product;
  UpdateNavigationEvent({required this.product});
}

class ProductFoundEvent extends NavigationEvent {
  final Product product;
  ProductFoundEvent({required this.product});
}

class UpdatePositionEvent extends NavigationEvent {
  final Product currentProduct;
  UpdatePositionEvent(this.currentProduct);
}

// Ajoutez cet événement dans vos événements existants
class UpdateNavigationEventDataRow extends NavigationEvent {
  final String decodedData;
  UpdateNavigationEventDataRow(this.decodedData);
}

// States
abstract class NavigationState {}

class NavigationInitial extends NavigationState {}

class NavigationLoading extends NavigationState {}

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

class NavigationError extends NavigationState {
  final String message;
  NavigationError(this.message);
}

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final StoreService _storeService;
  late final LocationService _locationService;
  late final LocationProductService _locationProductService;
  late final BluetoothScanService _bluetoothService = BluetoothScanService();
  late StreamController<String> _dataController;

  // TODO change to true value
  Grid? _cachedGrid;
  List<List<int>>? _cacheBeaconPositions;
  List<int>? _cacheProductPosition;
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

  Future<void> _onLoadNavigation(
    LoadNavigationEvent event,
    Emitter<NavigationState> emit,
  ) async {
    try {
      // Vérifier les permissions
      final bool permission = await checkPermissions();
      if (!permission) {
        throw Exception("Permissions not granted.");
      }
      // TODO
      // Cache init
      if (_cachedGrid == null) {
        print("Chargement du PLAN depuis $jsonFilePath");
        _cachedGrid = await _locationService.loadGridFromJson(jsonFilePath);
      }
      _cacheBeaconPositions ??=
          await _locationService.getBeaconPositions(jsonFilePath);

      _cacheProductPosition ??=
          await _locationService.getProductPosition(jsonFilePath);
      print("Starting Bluetooth scan...");

      // TODO Remerttre le connexion
      //await _bluetoothService.connectToDevice(
      //         device,
      //         onDataReceived: (String decodedData) async {
      //           if (decodedData != ""){
      //             final values = decodedData.split('/');
      //             final parsedData = <String, dynamic>{};
      //             // Construction du map de données
      //             for (int i = 0; i < values.length; i++) {
      //               parsedData['Tag $i'] = double.tryParse(values[i]);
      //             }

      //             final List<List<int>> shortestPath = await _locationService.findTargetPosition2(jsonEncode(parsedData));
      //             if (shortestPath != [-1000, -1000]){

      //             // As data is received, update the UI with the latest information
      //             emit(NavigationLoadedState(
      //               objectName: "Déodorant",
      //               instruction: _generateInstruction(shortestPath),
      //               arrowDirection: _calculateDirection(shortestPath),
      //               isLastProduct: false,
      //               isDone: false, // Connection and data reception are still ongoing
      //             ));
      //             }
      //           }
      //         },
      // };
      // Au lieu d'appeler emit ici, on ajoute un nouvel événement
      // add(UpdateNavigationEventDataRow(decodedData));
      // TODO fin

      //TODO Test
      // Démarrage du Timer périodique pour générer des variations
      _navigationTimer =
          Timer.periodic(const Duration(milliseconds: 2000), (timer) {
        // Valeurs de base
        final List<double> baseValues = [100, 100, 100];
        final random = Random();

        // Pour chaque valeur, ajouter une variation aléatoire entre -5 et +5
        final List<String> newValues = baseValues.map((base) {
          double variation =
              random.nextDouble() * 10 - 5; // variation entre -5 et +5
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

  /// Update of navigation change state of arow and position user
  void _onUpdateNavigation(
    UpdateNavigationEventDataRow event,
    Emitter<NavigationState> emit,
  ) async {
    final values = event.decodedData.split('/');
    final parsedData = <String, dynamic>{};
    for (int i = 0; i < values.length; i++) {
      parsedData['Tag $i'] = double.tryParse(values[i]);
    }

    final List<List<int>> shortestPath =
        await _locationService.FindPositionFinal(jsonEncode(parsedData),
            _cacheProductPosition!, _cacheBeaconPositions!, _cachedGrid!);
    //If is false return [-1000, -1000]
    print("shortestPath : $shortestPath");
    if (!const DeepCollectionEquality().equals(shortestPath, [
      [-1000, -1000]
    ])) {
      print("if ok");
      emit(NavigationLoadedState(
        objectName: "Riz",
        instruction: _generateInstruction(shortestPath),
        arrowDirection: _calculateDirection(shortestPath),
        isLastProduct: false,
        isDone: false,
      ));
    } else {
      print("Error :  [[-1000, -1000]] on the navigation");
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
}
