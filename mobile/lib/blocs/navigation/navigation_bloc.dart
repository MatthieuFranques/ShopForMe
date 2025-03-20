import 'dart:async';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobile/models/grid.dart';
import 'package:mobile/services/api_service.dart';
import 'package:mobile/services/bluetooth_service.dart';
import 'package:mobile/models/product.dart';
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
  late final InitNavigationService _initNavigationService =
      InitNavigationService();
  late final ApiService _apiService = ApiService(baseUrl: baseUrl);
  late StreamController<String> _dataController;

  // TODO change to true value
  Grid? _cachedGrid;
  List<List<int>>? _cachePath;
  List<int>? _cacheCurrentPosition = [0, 0];
  BluetoothDevice? _cacheDevice;

  // const String jsonFilePath = 'assets/demo/plan_test.json';
  String jsonFilePath = 'assets/demo/plan28_11_24.json';

  Timer? _navigationUpdateTimer;
  final List<Product> _products = [];
  int _currentProductIndex = 0;

  /// Initializes the NavigationBloc with the provided [StoreService] and sets up event handlers.
  NavigationBloc() : super(NavigationInitial()) {
    _locationService = LocationService();

    on<LoadNavigationEvent>(_onLoadNavigation);
    // on<UpdateNavigationEvent>(_onUpdateNavigation);
    on<UpdateNavigationEventDataRow>(_onUpdateNavigation);

    on<ProductFoundEvent>(_onProductFound);
    on<UpdatePositionEvent>(_onUpdatePosition);
  }

  /// Closes the bloc, cancels any ongoing navigation timers.
  @override
  Future<void> close() {
    print("Enter in 'Close' : navigation_bloc");
    _navigationUpdateTimer?.cancel();
    _navigationTimer?.cancel();
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

  /// Loads the navigation grid from a JSON file and starts periodic updates for navigation.
  /// [event] The event that triggered the navigation load.
  /// [emit] The emitter used to send states to the UI.
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
        _cachedGrid =
            await _initNavigationService.loadGridFromJson(jsonFilePath);
      }
      // print(await _apiService.getAllProductByShop(defaultShopId));
      // print(await _apiService.getShopById(defaultShopId));
      // print (await _apiService.getSectionForProduct(1));

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
  /// [event] The event that triggered the navigation load.
  /// [emit] The emitter used to send states to the UI.
  Future<void> _onLoadNavigation2(
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

      await _bluetoothService.getAnchorDistances(_cacheDevice!,
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

  /// Updates the current position based on the anchor distances received from BLE devices.
  /// [anchorDistances] The distances received from the BLE anchors used to calculate the position.
  Future<void> updatePosition(List<String> anchorDistances) async {
    // Toujours recalculer la position actuelle avec la triangulation
    _cacheCurrentPosition = await _locationService.getCurrentPosition(
        anchorDistances, _cachedGrid!);

    //call request API for send data to backend
    // TODO uncomment if the backend root is ok because the error break the recalculatePath
    // await _apiService.sendPosition(
    //   _cacheCurrentPosition!,
    //   _cachedGrid!.productPosition,
    //   _cachePath,
    // );

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
    //call request API for send data to backend
    await _apiService.sendPosition(
      _cacheCurrentPosition!,
      _cachedGrid!.productPosition,
      _cachePath!,
    );
  }
}
