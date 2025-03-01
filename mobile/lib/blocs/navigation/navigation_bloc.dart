import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/models/grid.dart';
import 'package:mobile/services/bluetooth_service.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/services/store_service.dart';
import 'package:mobile/services/navigation/location_service.dart';
import 'package:mobile/services/location_product_service.dart';
import 'package:mobile/services/navigation/direction_service.dart';
import 'package:mobile/services/navigation/init_navigation_service.dart';
import './navigation_event.dart';
import './navigation_state.dart';

Timer? _navigationTimer;

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final StoreService _storeService;
  late final LocationService _locationService;
  late final LocationProductService _locationProductService;
  late final BluetoothScanService _bluetoothService = BluetoothScanService();
  late final DirectionService _directionService;
  late final InitNavigationService _initNavigationService;
  late StreamController<String> _dataController;

  // TODO change to true value
  Grid? _cachedGrid;
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
        _cachedGrid = await _initNavigationService.loadGridFromJson(jsonFilePath);
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
      final List<Object> instruction = _directionService.getNextDirection(shortestPath!, _cacheCurrentPosition!);
      final instructionMsg = instruction[0] as String;
      final arrowDirection = instruction[1] as ArrowDirection;

      emit(NavigationLoadedState(
        objectName: "Riz",
        instruction: instructionMsg,
        arrowDirection: arrowDirection,
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
    const currentPath = null;
    //await _locationService.findTargetPosition(productPosition);

    if (currentPath != null && currentPath.isNotEmpty) {
      final List<Object> instruction = _directionService.getNextDirection(currentPath, _cacheCurrentPosition!);
      final instructionMsg = instruction[0] as String;
      final arrowDirection = instruction[1] as ArrowDirection;
      emit(NavigationLoadedState(
        objectName: product.name,
        arrowDirection: arrowDirection,
        instruction: instructionMsg,
        isLastProduct: _currentProductIndex == _products.length - 1,
      ));
    } else {
      emit(NavigationError("Impossible de trouver un chemin vers le produit"));
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
      await recalculatePath(anchorDistances);
      return;
    }
    if (!_locationService.isPositionNearPath(_cacheCurrentPosition!, _cachePath!)) {
      print("Utilisateur hors chemin, recalcul du plus court chemin...");
      await recalculatePath(anchorDistances);
    }
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
