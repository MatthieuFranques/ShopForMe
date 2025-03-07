import 'dart:async';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobile/models/grid.dart';
import 'package:mobile/services/api_service.dart';
import 'package:mobile/services/bluetooth_service.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/services/navigation/compass_service.dart' as compass;
import 'package:mobile/services/navigation/location_service.dart';
import 'package:mobile/services/navigation/direction_service.dart';
import 'package:mobile/services/navigation/init_navigation_service.dart';
import './navigation_event.dart';
import './navigation_state.dart';
import 'package:mobile/utils/constants.dart';

Timer? _navigationTimer;

/// A Bloc that handles navigation events and states related to the user's location,
/// Bluetooth device interaction, and product pathfinding.
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  late final LocationService _locationService;
  late final BluetoothScanService _bluetoothService = BluetoothScanService();
  late final DirectionService _directionService = DirectionService();
  late final InitNavigationService _initNavigationService = InitNavigationService();
  late final ApiService _apiService = ApiService(baseUrl: baseUrl);
  late final compass.CompassService _compassService = compass.CompassService();
  late StreamSubscription? _compassSubscription;

  // Cache values for various navigation data
  Grid? _cachedGrid;
  List<List<int>>? _cachePath;
  List<int>? _cacheCurrentPosition = [0, 0];
  List<int>? _cacheTargetPosition;
  BluetoothDevice? _cacheDevice;
  double _compassDirection = 0.0;

  // Path to the store layout JSON file
  String jsonFilePath = 'assets/demo/plan28_11_24.json';

  Timer? _navigationUpdateTimer;
  final List<Product> _products = [];
  int _currentProductIndex = 0;

  /// Initializes the NavigationBloc with the provided parameters and sets up event handlers.
  NavigationBloc() : super(NavigationInitial()) {
    _locationService = LocationService();

    // Using the test implementation by default
    on<LoadNavigationEvent>(_onLoadNavigation);
    on<UpdateNavigationEventDataRow>(_onUpdateNavigation);
    on<ProductFoundEvent>(_onProductFound);
    on<UpdatePositionEvent>(_onUpdatePosition);
    on<CompassUpdateEvent>(_onCompassUpdate);

    // Subscribe to compass updates
    _compassSubscription = _compassService.compassStream.listen((direction) {
      _compassDirection = direction;
      add(CompassUpdateEvent(direction));
    });
  }

  /// Closes the bloc, cancels any ongoing navigation timers.
  @override
  Future<void> close() {
    print("Enter in 'Close' : navigation_bloc");
    _navigationUpdateTimer?.cancel();
    _navigationTimer?.cancel();
    _compassSubscription?.cancel();
    return super.close();
  }

  /// Starts periodic updates for navigation when a product is found.
  /// [product] The product that the navigation updates will be based on.
  void _startNavigationUpdates(Product product) {
    _navigationUpdateTimer?.cancel();
    _navigationUpdateTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => add(UpdatePositionEvent(product)),
    );
  }

  /// Handles updates from the compass sensor
  /// [event] The event containing the compass direction
  /// [emit] The emitter used to send states to the UI
  void _onCompassUpdate(
    CompassUpdateEvent event,
    Emitter<NavigationState> emit,
  ) {
    if (state is NavigationLoadedState) {
      final currentState = state as NavigationLoadedState;
      
      // Calculate the adjusted angle between the current compass direction and target
      double adjustedAngle = _getAdjustedDirectionFromArrow(currentState.arrowDirection);
      
      emit(NavigationLoadedState(
        objectName: currentState.objectName,
        instruction: currentState.instruction,
        arrowDirection: currentState.arrowDirection,
        isLastProduct: currentState.isLastProduct,
        isDone: currentState.isDone,
        compassDirection: event.direction,
        adjustedAngle: adjustedAngle,
      ));
    }
  }

  /// Calculates the adjusted angle between the compass direction and arrow direction
  /// [arrowDirection] The direction to display as an arrow
  /// @returns The angle in degrees to rotate the compass arrow
  double _getAdjustedDirectionFromArrow(ArrowDirection arrowDirection) {
    // Convert ArrowDirection to degrees
    double targetAngle = 0.0;
    switch (arrowDirection) {
      case ArrowDirection.nord:
        targetAngle = 0.0;
        break;
      case ArrowDirection.est:
        targetAngle = 90.0;
        break;
      case ArrowDirection.sud:
        targetAngle = 180.0;
        break;
      case ArrowDirection.ouest:
        targetAngle = 270.0;
        break;
    }
    
    // Calculate the adjusted angle (angle the user needs to turn to)
    return (targetAngle - _compassDirection + 360) % 360;
  }

  /// Loads the navigation grid from a JSON file and starts periodic updates using simulated data
  /// This test implementation generates mock ESP device signals for development and testing
  /// [event] The event that triggered the navigation load.
  /// [emit] The emitter used to send states to the UI.
  Future<void> _onLoadNavigation(
    LoadNavigationEvent event,
    Emitter<NavigationState> emit,
  ) async {
    try {
      // Cache initialization
      if (_cachedGrid == null) {
        print("Chargement du PLAN depuis $jsonFilePath");
        _cachedGrid = await _initNavigationService.loadGridFromJson(jsonFilePath);
      }
      
      // Store products for navigation
      if (event.products.isNotEmpty) {
        _products.clear();
        _products.addAll(event.products);
        _currentProductIndex = 0;
        
        // Get the position of the first product
        if (_products.isNotEmpty) {
          try {
            _cacheTargetPosition = await _initNavigationService.getProductPosition();
          } catch (e) {
            print("Erreur lors de la récupération de la position du produit: $e");
          }
        }
      }
      
      // print(await _apiService.getAllProductByShop(defaultShopId));
      // print(await _apiService.getShopById(defaultShopId));
      // print(await _apiService.getSectionForProduct(1));

      // Create a timer that simulates ESP device signals by generating random distance values
      _navigationTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
        // Base values for the anchor distances
        final List<double> baseValues = [400, 100, 200];
        final random = Random();

        // For each base value, add a random variation between -50 and +150
        final List<String> newValues = baseValues.map((base) {
          final double variation = random.nextDouble() * 200 - 50;
          final double newValue = base + variation;
          return newValue.toStringAsFixed(1); // 1 decimal place
        }).toList();

        // Join the values with "/" to create a simulated data row
        final String decodedData = newValues.join("/");
        
        // Send the simulated data to the update handler
        add(UpdateNavigationEventDataRow(decodedData));
      });
      
      // Emit initial state
      emit(NavigationLoadedState(
        objectName: _products.isNotEmpty ? _products[_currentProductIndex].name : "Produit inconnu",
        instruction: "Initialisation de la navigation...",
        arrowDirection: ArrowDirection.nord,
        isLastProduct: false,
        isDone: false,
        compassDirection: _compassDirection,
        adjustedAngle: 0.0,
      ));
    } catch (e) {
      print("Error: $e");
      if (!emit.isDone) {
        emit(NavigationError(e.toString()));
      }
    }
  }
  
  /// Loads navigation via Bluetooth Low Energy (BLE) by checking permissions
  /// and obtaining anchor distances from the Bluetooth device.
  /// This is the real implementation that connects to actual ESP devices
  /// [event] The event that triggered the navigation load.
  /// [emit] The emitter used to send states to the UI.
  Future<void> _onLoadNavigationReal(
    LoadNavigationEvent event,
    Emitter<NavigationState> emit,
  ) async {
    try {
      // Cache initialization
      if (_cachedGrid == null) {
        print("Chargement du PLAN depuis $jsonFilePath");
        _cachedGrid = await _initNavigationService.loadGridFromJson(jsonFilePath);
      }
      
      // Store products for navigation
      if (event.products.isNotEmpty) {
        _products.clear();
        _products.addAll(event.products);
        _currentProductIndex = 0;
        
        // Get the position of the first product
        if (_products.isNotEmpty) {
          try {
            _cacheTargetPosition = await _initNavigationService.getProductPosition();
          } catch (e) {
            print("Erreur lors de la récupération de la position du produit: $e");
          }
        }
      }

      // Initialize Bluetooth connection
      await _initNavigationService.checkPermissions();
      _cacheDevice == null
          ? _cacheDevice = await _bluetoothService.getBluetoothDevice()
          : null;

      // Subscribe to data updates from Bluetooth device
      await _bluetoothService.getAnchorDistances(_cacheDevice!,
          onDataReceived: (String decodedData) async {
        print("decodedData : $decodedData");
        if (decodedData != "") {
          print(" if (decodedData != '') {");
          add(UpdateNavigationEventDataRow(decodedData));
        }
      });

      // Emit initial state
      emit(NavigationLoadedState(
        objectName: _products.isNotEmpty ? _products[_currentProductIndex].name : "Produit inconnu",
        instruction: "Initialisation de la navigation...",
        arrowDirection: ArrowDirection.nord,
        isLastProduct: false,
        isDone: false,
        compassDirection: _compassDirection,
        adjustedAngle: 0.0,
      ));
    } catch (e) {
      print("Error: $e");
      if (!emit.isDone) {
        emit(NavigationError(e.toString()));
      }
    }
  }

  /// Handles the update of the navigation state based on new anchor distances.
  /// [event] The event containing the decoded data from anchor distances.
  /// [emit] The emitter used to send states to the UI.
  void _onUpdateNavigation(
    UpdateNavigationEventDataRow event,
    Emitter<NavigationState> emit,
  ) async {
    final anchorDistances = event.decodedData.split("/");
    print("anchorDistances : $anchorDistances");
    await updatePosition(anchorDistances);

    print("shortestPath : $_cachePath");
    if (!const DeepCollectionEquality().equals(_cachePath, null)) {
      print("Shortest path non null, getNextDirection");
      print("Cache current position $_cacheCurrentPosition");
      final List<Object> instruction = _directionService.getNextDirection(
          _cachePath!, _cacheCurrentPosition!);
      final instructionMsg = instruction[0] as String;
      final arrowDirection = instruction[1] as ArrowDirection;
      print("InstructionMsg: $instructionMsg, arrowDirection: $arrowDirection");

      // Calculate adjusted angle
      double adjustedAngle = _getAdjustedDirectionFromArrow(arrowDirection);

      emit(NavigationLoadedState(
        objectName: _products.isNotEmpty ? _products[_currentProductIndex].name : "Riz",
        instruction: instructionMsg,
        arrowDirection: arrowDirection,
        isLastProduct: false,
        isDone: false,
        compassDirection: _compassDirection,
        adjustedAngle: adjustedAngle,
      ));
    } else {
      print("Error : null on the navigation");
    }
  }

  /// Handles the event when a product is found and updates the navigation state.
  /// [event] The event containing the found product.
  /// [emit] The emitter used to send states to the UI.
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
          compassDirection: _compassDirection,
          adjustedAngle: 0.0,
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

  /// Updates the navigation state by calculating the direction towards the next product.
  /// [event] The event containing the current product.
  /// [emit] The emitter used to send states to the UI.
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

  /// Updates the navigation by calculating the next direction towards a product based on the current path.
  /// [product] The product the navigation is guiding to.
  /// [emit] The emitter used to send states to the UI.
  Future<void> _updateNavigation(
      Product product, Emitter<NavigationState> emit) async {
    const currentPath = null;
    //await _locationService.findTargetPosition(productPosition);

    if (currentPath != null && currentPath.isNotEmpty) {
      final List<Object> instruction = _directionService.getNextDirection(
          currentPath, _cacheCurrentPosition!);
      final instructionMsg = instruction[0] as String;
      final arrowDirection = instruction[1] as ArrowDirection;
      
      // Calculate adjusted angle
      double adjustedAngle = _getAdjustedDirectionFromArrow(arrowDirection);
      
      emit(NavigationLoadedState(
        objectName: product.name,
        arrowDirection: arrowDirection,
        instruction: instructionMsg,
        isLastProduct: _currentProductIndex == _products.length - 1,
        compassDirection: _compassDirection,
        adjustedAngle: adjustedAngle,
      ));
    } else {
      emit(NavigationError("Impossible de trouver un chemin vers le produit"));
    }
  }

  /// Updates the current position based on the anchor distances received from BLE devices.
  /// [anchorDistances] The distances received from the BLE anchors used to calculate the position.
  Future<void> updatePosition(List<String> anchorDistances) async {
    // Always recalculate current position with triangulation
    _cacheCurrentPosition = await _locationService.getCurrentPosition(
        anchorDistances, _cachedGrid!);

    if (_cachePath == null || _cachePath!.isEmpty) {
      print("Si aucun chemin n'est défini, recalculer le chemin initial");
      await recalculatePath(anchorDistances);
      return;
    }
    if (!_locationService.isPositionNearPath(
        _cacheCurrentPosition!, _cachePath!)) {
      print("Utilisateur hors chemin, recalcul du plus court chemin...");
      await recalculatePath(anchorDistances);
    }
  }

  /// Reloads the path to the target product and updates the cached path and current position.
  /// [anchorDistances] The distances received from the BLE anchors used to recalculate the path.
  Future<void> recalculatePath(List<String> anchorDistances) async {
    _cachePath = await _locationService.getShortestPath(
      anchorDistances,
      _cachedGrid!,
    );
  }
}