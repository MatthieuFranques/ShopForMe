import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/product.dart';
import '../services/store_service.dart';
import '../services/location_service.dart';
import '../services/location_product_service.dart';

// Énumération des directions possibles pour la navigation
enum ArrowDirection { nord, sud, est, ouest }

// Définition des événements qui peuvent être traités par le Bloc
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

// Définition des états possibles du Bloc
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

// Implémentation principale du Bloc de navigation
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final StoreService _storeService;
  late final LocationService _locationService;
  late final LocationProductService _locationProductService;

  // Liste des produits à trouver et index du produit courant
  List<Product> _products = [];
  int _currentProductIndex = 0;

  // Gestion des souscriptions pour le nettoyage
  StreamSubscription? _bluetoothDataSubscription;
  Timer? _navigationUpdateTimer;

  NavigationBloc(this._storeService) : super(NavigationInitial()) {
    _locationService = LocationService();
    _locationProductService = LocationProductService(_storeService);

    // Enregistrement des gestionnaires d'événements
    on<LoadNavigationEvent>(_onLoadNavigation);
    on<UpdateNavigationEvent>(_onUpdateNavigation);
    on<ProductFoundEvent>(_onProductFound);
    on<UpdatePositionEvent>(_onUpdatePosition);
  }

  // Gestion du chargement initial de la navigation
  Future<void> _onLoadNavigation(
    LoadNavigationEvent event,
    Emitter<NavigationState> emit,
  ) async {
    print("DEBUG: Début de LoadNavigation");
    emit(NavigationLoading());

    try {
      final bool permission = await checkPermissions();
      print("DEBUG: Permissions vérifiées: $permission");

      if (permission) {
        _products = event.products;
        _currentProductIndex = 0;

        if (_products.isEmpty) {
          emit(NavigationError('Aucun produit dans la liste'));
          return;
        }

        // Configuration de la communication Bluetooth
        FlutterBlue.instance.scan().listen((scanResult) {
          if (scanResult.device.name == 'ESP32_BLE') {
            print("DEBUG: ESP32 trouvé");
            FlutterBlue.instance.stopScan();

            scanResult.device.connect().then((_) async {
              print("DEBUG: Connecté à l'ESP32");
              final services = await scanResult.device.discoverServices();

              await _setupBluetoothCharacteristic(services, emit);
            });
          }
        });
      } else {
        emit(NavigationError('Permissions refusées'));
      }
    } catch (e) {
      print("DEBUG: Erreur globale: $e");
      if (!emit.isDone) {
        emit(NavigationError(e.toString()));
      }
    }
  }

  // Configuration des caractéristiques Bluetooth
  Future<void> _setupBluetoothCharacteristic(
    List<BluetoothService> services,
    Emitter<NavigationState> emit,
  ) async {
    print("DEBUG: Début de _setupBluetoothCharacteristic");

    // Annulation de toute souscription existante
    await _bluetoothDataSubscription?.cancel();

    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          print("DEBUG: Caractéristique avec notification trouvée");
          await characteristic.setNotifyValue(true);

          _bluetoothDataSubscription = characteristic.value.listen(
            (data) async {
              print("DEBUG: Données Bluetooth reçues");
              if (emit.isDone) {
                await _processBluetoothData(data, emit);
              } else {
                print("DEBUG: Émetteur terminé, données ignorées");
              }
            },
            onError: (error) {
              print("DEBUG: Erreur dans la réception Bluetooth: $error");
              if (!emit.isDone) {
                emit(NavigationError(error.toString()));
              }
            },
            cancelOnError: false,
          );

          print("DEBUG: Souscription Bluetooth configurée");
        }
      }
    }
    print("DEBUG: Fin de _setupBluetoothCharacteristic");
  }

  // Traitement des données reçues via Bluetooth
  Future<void> _processBluetoothData(
    List<int> data,
    Emitter<NavigationState> emit,
  ) async {
    print("DEBUG: Début de _processBluetoothData");
    print("DEBUG: État de emit.isDone: ${emit.isDone}");

    if (emit.isDone) {
      try {
        print("DEBUG: Décodage des données");
        final decodedData = utf8.decode(data);
        print("DEBUG: Données décodées: $decodedData");

        if (decodedData.isNotEmpty) {
          print("DEBUG: Traitement des données non vides");
          final values = decodedData.split('/');
          print("DEBUG: Valeurs séparées: $values");

          final parsedData = <String, dynamic>{};
          for (int i = 0; i < values.length; i++) {
            parsedData['Tag $i'] = double.tryParse(values[i]);
          }
          print("DEBUG: Données parsées: $parsedData");

          print("DEBUG: Appel de findTargetPosition2");
          final shortestPath = await _locationService.findTargetPosition2(
            jsonEncode(parsedData),
          );
          print("DEBUG: Chemin le plus court reçu: $shortestPath");

          print("DEBUG: Avant _updateNavigationWithPath");
          print("DEBUG: État de emit.isDone avant mise à jour: ${emit.isDone}");
          await _updateNavigationWithPath(shortestPath, emit);
          print("DEBUG: Après _updateNavigationWithPath");
        }
      } catch (e) {
        print("DEBUG: Erreur traitement données: $e");
        if (!emit.isDone) {
          emit(NavigationError(e.toString()));
        }
      }
    } else {
      print("DEBUG: _processBluetoothData ignoré car emit.isDone est true");
    }
    print("DEBUG: Fin de _processBluetoothData");
  }

  // Mise à jour de la navigation avec le nouveau chemin calculé
  Future<void> _updateNavigationWithPath(
    List<List<int>>? shortestPath,
    Emitter<NavigationState> emit,
  ) async {
    if (emit.isDone &&
        shortestPath != null &&
        !listEquals(shortestPath, [
          [-1000, -1000]
        ])) {
      final instruction = _generateInstruction(shortestPath);
      final arrowDirection = _calculateDirection(shortestPath);

      emit(NavigationLoadedState(
        objectName: _products[_currentProductIndex].name,
        arrowDirection: arrowDirection,
        instruction: instruction,
        isLastProduct: _currentProductIndex == _products.length - 1,
      ));
    }
  }

  // Gestion de la mise à jour de position
  Future<void> _onUpdatePosition(
    UpdatePositionEvent event,
    Emitter<NavigationState> emit,
  ) async {
    if (!emit.isDone) {
      try {
        await _updateNavigation(event.currentProduct, emit);
      } catch (e) {
        if (!emit.isDone) {
          emit(NavigationError(e.toString()));
        }
      }
    }
  }

  // Gestion de la mise à jour de navigation
  Future<void> _onUpdateNavigation(
    UpdateNavigationEvent event,
    Emitter<NavigationState> emit,
  ) async {
    if (!emit.isDone) {
      emit(NavigationLoading());
      try {
        await _updateNavigation(event.product, emit);
      } catch (e) {
        if (!emit.isDone) {
          emit(NavigationError(e.toString()));
        }
      }
    }
  }

  // Gestion d'un produit trouvé
  Future<void> _onProductFound(
    ProductFoundEvent event,
    Emitter<NavigationState> emit,
  ) async {
    try {
      _currentProductIndex++;

      if (_currentProductIndex >= _products.length) {
        if (!emit.isDone) {
          emit(NavigationLoadedState(
            objectName: "Terminé !",
            instruction: "Tous les produits ont été trouvés",
            arrowDirection: ArrowDirection.nord,
            isLastProduct: true,
          ));
        }
        return;
      }

      if (!emit.isDone) {
        await _updateNavigation(_products[_currentProductIndex], emit);
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(NavigationError(e.toString()));
      }
    }
  }

  // Mise à jour de la navigation pour un produit donné
  Future<void> _updateNavigation(
    Product product,
    Emitter<NavigationState> emit,
  ) async {
    if (emit.isDone) return;

    try {
      final productPosition =
          await _locationProductService.getProductPosition(product);
      final currentPath =
          await _locationService.findTargetPosition(productPosition);

      if (!emit.isDone && currentPath != null && currentPath.isNotEmpty) {
        final direction = _calculateDirection(currentPath);
        final instruction = _generateInstruction(currentPath);

        emit(NavigationLoadedState(
          objectName: product.name,
          arrowDirection: direction,
          instruction: instruction,
          isLastProduct: _currentProductIndex == _products.length - 1,
        ));
      } else if (!emit.isDone) {
        emit(
            NavigationError("Impossible de trouver un chemin vers le produit"));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(NavigationError(e.toString()));
      }
    }
  }

  // Calcul de la direction à partir du chemin
  ArrowDirection _calculateDirection(List<List<int>> path) {
    if (path.length < 2) return ArrowDirection.nord;

    final current = path[0];
    final next = path[1];

    if (next[0] < current[0]) return ArrowDirection.nord;
    if (next[0] > current[0]) return ArrowDirection.sud;
    if (next[1] < current[1]) return ArrowDirection.ouest;
    return ArrowDirection.est;
  }

  // Génération des instructions de navigation
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

  // Vérification des permissions nécessaires
  Future<bool> checkPermissions() async {
    return await Permission.bluetoothScan.request().isGranted &&
        await Permission.bluetoothConnect.request().isGranted &&
        await Permission.locationWhenInUse.request().isGranted;
  }

  // Nettoyage des ressources à la fermeture du Bloc
  @override
  Future<void> close() async {
    await _bluetoothDataSubscription?.cancel();
    _navigationUpdateTimer?.cancel();
    return super.close();
  }
}
