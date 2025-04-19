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
import 'package:mobile/services/navigation/compass_service.dart';
import 'package:mobile/services/navigation/location_service.dart';
import 'package:mobile/services/navigation/direction_service.dart';
import 'package:mobile/services/navigation/init_navigation_service.dart';
import 'package:mobile/models/zoneInstruction.dart';
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
  late final InitNavigationService _initNavigationService =
      InitNavigationService();
  late final ApiService _apiService = ApiService(baseUrl: baseUrl);
  late final compass.CompassService _compassService = compass.CompassService();
  late StreamSubscription? _compassSubscription;

  // Cache values for various navigation data
  Grid? _cachedGrid;
  List<List<int>>? _cachePath;
  List<int>? _cacheCurrentPosition = [0, 0];
  List<int>? _cacheTargetPosition;
  List<ZoneInstruction>? _cacheZoneInstruction;
  ArrowDirection? _cacheArrowDirection;
  String? _cacheInstruction;
  BluetoothDevice? _cacheDevice;
  double _compassDirection = 0.0;

  // Path to the store layout JSON file
  String jsonFilePath = 'assets/demo/plan-keynote-2025.json';

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
    on<CompassUpdateEvent>(_onCompassUpdate);
  }

  /// Closes the bloc, cancels any ongoing navigation timers.
  @override
  Future<void> close() {
    print("Enter in 'Close' : navigation_bloc");
    _navigationUpdateTimer?.cancel();
    _navigationTimer?.cancel();
    _compassSubscription?.cancel();
    _cacheDevice!.disconnect();
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
      double adjustedAngle = _compassService
          .getAdjustedDirectionFromArrow(currentState.arrowDirection);

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

  /// Loads the navigation grid from a JSON file and starts periodic updates using simulated data
  /// This test implementation generates mock ESP device signals for development and testing
  /// [event] The event that triggered the navigation load.
  /// [emit] The emitter used to send states to the UI.
  Future<void> _onLoadNavigationFake(
    LoadNavigationEvent event,
    Emitter<NavigationState> emit,
  ) async {
    try {
      // TODO
      // Cache init
      if (_cachedGrid == null) {
        print("Chargement du PLAN depuis $jsonFilePath");
        _cachedGrid =
            await _initNavigationService.loadGridFromJson(jsonFilePath);
      }
      // print(await _apiService.getAllProductByShop(defaultShopId));
      // print(await _apiService.getShopById(defaultShopId));
      // print(await _apiService.getSectionForProduct(1));
      // Subscribe to compass updates

      _compassSubscription = _compassService.compassStream.listen((direction) {
        _compassDirection = direction;
        add(CompassUpdateEvent(direction));
      });

      _navigationTimer =
          Timer.periodic(const Duration(milliseconds: 1000), (timer) {
        // Valeurs de base
        final List<double> baseValues = [400, 100, 200];
        final random = Random();

        // Pour chaque valeur, ajouter une variation aléatoire entre -5 et +5
        final List<String> newValues = baseValues.map((base) {
          final double variation =
              random.nextDouble() * 200 - 50; // variation entre -5 et +5
          final double newValue = base + variation;
          return newValue.toStringAsFixed(1); // 1 chiffre après la virgule
        }).toList();

        // Decode data row
        final String decodedData = newValues.join("/");
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

  /// Loads navigation via Bluetooth Low Energy (BLE) by checking permissions
  /// and obtaining anchor distances from the Bluetooth device.
  /// This is the real implementation that connects to actual ESP devices
  /// [event] The event that triggered the navigation load.
  /// [emit] The emitter used to send states to the UI.
  Future<void> _onLoadNavigation(
    LoadNavigationEvent event,
    Emitter<NavigationState> emit,
  ) async {
    try {
      // TODO
      await _initNavigationService.checkPermissions();
      _cachedGrid == null
          ? _cachedGrid =
              await _initNavigationService.loadGridFromJson(jsonFilePath)
          : null;
      _cacheDevice == null
          ? _cacheDevice = await _bluetoothService.getBluetoothDevice()
          : null;

      _compassSubscription = _compassService.compassStream.listen((direction) {
        _compassDirection = direction;
        add(CompassUpdateEvent(direction));
      });
      await _bluetoothService.getAnchorDistances(_cacheDevice!,
          onDataReceived: (String decodedData) async {
        print("decodedData : $decodedData");
        if (decodedData != "") {
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

  /// Handles the update of the navigation state based on new anchor distances.
  /// [event] The event containing the decoded data from anchor distances.
  /// [emit] The emitter used to send states to the UI.
  void _onUpdateNavigation(
    UpdateNavigationEventDataRow event,
    Emitter<NavigationState> emit,
  ) async {
    final anchorDistances = event.decodedData.split("/");
    print("anchorDistances : $anchorDistances");

    // _cachedGrid!.toStringData();

    // update Current position
    await updatePosition(anchorDistances);

    print("shortestPath : $_cachePath");
    if (!const DeepCollectionEquality().equals(_cachePath, null)) {
      print("Shortest path non null, getNextDirection");
      print("Cache current position $_cacheCurrentPosition");

      final List<Object> instruction = _directionService.getNextDirection(
          _cachePath!, _cacheCurrentPosition!, _cacheZoneInstruction!);
      if (instruction[0] == Null && instruction[1] == Null) {
        print("User is not in a Zone !");
      } else if (instruction[0] == "Finished") {
        //init _product because is null
        final newProduct = Product(
          id: '1',
          name: 'Chocolat Noir',
          category: 'Alimentaire',
          rayon: 'Épicerie',
        );
        _products.add(newProduct);
        await _onProductFound(ProductFoundEvent(product: _products[0]), emit);
      } else {
        _cacheInstruction = instruction[0] as String;
        _cacheArrowDirection = instruction[1] as ArrowDirection;
      }
      print(
          "InstructionMsg: $_cacheInstruction, arrowDirection: $_cacheArrowDirection");

      // Calculate adjusted angle
      double adjustedAngle =
          _compassService.getAdjustedDirectionFromArrow(_cacheArrowDirection!);

      emit(NavigationLoadedState(
        objectName:
            _products.isNotEmpty ? _products[_currentProductIndex].name : "Riz",
        instruction:
            //  _cacheInstruction != null && _cacheInstruction!.isNotEmpty
            //     ? _cacheInstruction!
            //     : " "
            "Avancer vers la direction de la flèche",
        arrowDirection: _cacheArrowDirection!,
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

      // if (_currentProductIndex >= _products.length) {
      emit(NavigationLoadedState(
        objectName: "Terminé !",
        instruction: "Vous êtes arrivé au produit",
        arrowDirection: ArrowDirection.nord,
        isLastProduct: true,
        shouldPopAfterDelay: true,
      ));
      close();

      return;
      // }

      // _startNavigationUpdates(_products[_currentProductIndex]);
    } catch (e) {
      emit(NavigationError(e.toString()));
    }
  }

  /// Updates the current position based on the anchor distances received from BLE devices.
  /// [anchorDistances] The distances received from the BLE anchors used to calculate the position.
  Future<void> updatePosition(List<String> anchorDistances) async {
    // Always recalculate current position with triangulation
    _cacheCurrentPosition = await _locationService.getCurrentPosition(
        anchorDistances, _cachedGrid!);

    //call request API for send data to backend
    // TODO uncomment if the backend root is ok because the error break the recalculatePath
    if (_cachePath != null) {
      await _apiService.sendPosition(
        _cacheCurrentPosition!,
        _cachedGrid!.productPosition,
        _cachePath,
      );
    }

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

    _cacheZoneInstruction = getDirectionalZones(_cachePath!);
    _cacheArrowDirection = _directionService.calculateDirection(_cachePath!);
  }
}
