import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobile/services/bluetooth_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/product.dart';
import '../services/store_service.dart';
import '../services/location_service.dart';
import '../services/location_product_service.dart';

enum ArrowDirection { nord, sud, est, ouest }

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

// States
abstract class NavigationState {}

class NavigationInitial extends NavigationState {}

class NavigationLoading extends NavigationState {}

class NavigationLoadedState extends NavigationState {
  final String objectName;
  final String instruction;
  final ArrowDirection arrowDirection;
  final bool isLastProduct;

  NavigationLoadedState({
    required this.objectName,
    required this.instruction,
    required this.arrowDirection,
    this.isLastProduct = false,
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

  Timer? _navigationUpdateTimer;
  List<Product> _products = [];
  int _currentProductIndex = 0;

  NavigationBloc(this._storeService) : super(NavigationInitial()) {
    _locationService = LocationService();
    _locationProductService = LocationProductService(_storeService);

    on<LoadNavigationEvent>(_onLoadNavigation);
    on<UpdateNavigationEvent>(_onUpdateNavigation);
    on<ProductFoundEvent>(_onProductFound);
    on<UpdatePositionEvent>(_onUpdatePosition);
  }

  @override
  Future<void> close() {
    _navigationUpdateTimer?.cancel();
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
    emit(NavigationLoading());
    //Test blue
    final List<String> devicesList = [];
    // BluetoothDevice deviceDeMerde;
    Map<String, dynamic> data = {};

    try {
      final bool permission = await checkPermissions();
      if (permission == true) {
        _bluetoothService.startScan((BluetoothDevice device) {
          devicesList.add(device.name);
          print("Discovered device: ${device.name}");

          _bluetoothService.connectToDevice(device, (receivedData) {
            // Process received data
            print("Received data: $receivedData");
            if (receivedData != {}) {
              data = receivedData;
              String jsonString = jsonEncode(data);
              _locationService.findTargetPosition2(jsonString);
            }
          });
        });
        // String jsonString = jsonEncode(data);
        // _locationService.findTargetPosition2(jsonString);
        // print("///////////////////////////Data : ${data}");

        _products = event.products;
        _currentProductIndex = 0;

        if (_products.isEmpty) {
          emit(NavigationError('Aucun produit dans la liste'));
          return;
        }

        await _updateNavigation(_products[_currentProductIndex], emit);
        _startNavigationUpdates(_products[_currentProductIndex]);
      }
    } catch (e) {
      emit(NavigationError(e.toString()));
    }
  }

  Future<void> _onUpdateNavigation(
    UpdateNavigationEvent event,
    Emitter<NavigationState> emit,
  ) async {
    emit(NavigationLoading());
    try {
      await _updateNavigation(event.product, emit);
      _startNavigationUpdates(event.product);
    } catch (e) {
      emit(NavigationError(e.toString()));
    }
  }

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

  Future<void> _updateNavigation(
      Product product, Emitter<NavigationState> emit) async {
    final productPosition =
        await _locationProductService.getProductPosition(product);
    final currentPath =
        await _locationService.findTargetPosition(productPosition);

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
}
