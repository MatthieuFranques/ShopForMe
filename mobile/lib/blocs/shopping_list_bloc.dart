// shopping_list_bloc.dart
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/models/shopping_list.dart';
import 'package:mobile/models/shop.dart';

// Events
abstract class ShoppingListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadShoppingList extends ShoppingListEvent {}

class AddProductToShoppingList extends ShoppingListEvent {
  final Product product;
  AddProductToShoppingList(this.product);

  @override
  List<Object?> get props => [product];
}

class RemoveProductFromList extends ShoppingListEvent {
  final String productId;
  RemoveProductFromList(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ValidateShoppingList extends ShoppingListEvent {}

// States
abstract class ShoppingListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShoppingListLoading extends ShoppingListState {}

class ShoppingListLoaded extends ShoppingListState {
  final ShoppingList shoppingList;
  final List<String> validationErrors;
  final List<Product> invalidProducts;

  ShoppingListLoaded(
    this.shoppingList, {
    this.validationErrors = const [],
    this.invalidProducts = const [],
  });

  @override
  List<Object?> get props => [shoppingList, validationErrors, invalidProducts];
}

class ShoppingListError extends ShoppingListState {
  final String message;
  ShoppingListError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  final Shop? currentShop;
  
  ShoppingListBloc({this.currentShop}) : super(ShoppingListLoading()) {
    on<LoadShoppingList>(_onLoadShoppingList);
    on<AddProductToShoppingList>(_onAddProductToShoppingList);
    on<RemoveProductFromList>(_onRemoveProductFromList);
    on<ValidateShoppingList>(_onValidateShoppingList);
  }

  Future<ShoppingList> _loadShoppingListFromAssets() async {
    try {
      final jsonString = await rootBundle.loadString('assets/datas.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return ShoppingList.fromJson(jsonData);
    } catch (e) {
      print('Error loading shopping list: $e');
      throw Exception('Failed to load shopping list: $e');
    }
  }

  bool _isRayonValid(String rayon) {
    if (currentShop == null) return true; // Skip validation if no shop
    
    return currentShop!.layout.any((row) => 
      row.any((cell) => 
        cell.type == "RAYON" && cell.name.toLowerCase() == rayon.toLowerCase()
      )
    );
  }

  Future<void> _onLoadShoppingList(
    LoadShoppingList event, 
    Emitter<ShoppingListState> emit
  ) async {
    emit(ShoppingListLoading());
    
    try {
      final shoppingList = await _loadShoppingListFromAssets();
      final validationErrors = <String>[];
      final invalidProducts = <Product>[];

      // Validate each product's rayon if we have a shop
      if (currentShop != null) {
        for (final product in shoppingList.products) {
          if (!_isRayonValid(product.rayon)) {
            validationErrors.add(
              'Le rayon "${product.rayon}" pour le produit "${product.name}" n\'existe pas dans ce magasin'
            );
            invalidProducts.add(product);
          }
        }
      }

      emit(ShoppingListLoaded(
        shoppingList,
        validationErrors: validationErrors,
        invalidProducts: invalidProducts,
      ));
    } catch (error) {
      emit(ShoppingListError('Failed to load shopping list: $error'));
    }
  }

  Future<void> _onAddProductToShoppingList(
    AddProductToShoppingList event,
    Emitter<ShoppingListState> emit,
  ) async {
    if (state is ShoppingListLoaded) {
      final currentState = state as ShoppingListLoaded;
      final validationErrors = List<String>.from(currentState.validationErrors);
      final invalidProducts = List<Product>.from(currentState.invalidProducts);

      // Validate the new product's rayon
      if (currentShop != null && !_isRayonValid(event.product.rayon)) {
        validationErrors.add(
          'Le rayon "${event.product.rayon}" pour le produit "${event.product.name}" n\'existe pas dans ce magasin'
        );
        invalidProducts.add(event.product);
      }

      final updatedProducts = List<Product>.from(currentState.shoppingList.products)
        ..add(event.product);

      final updatedShoppingList = ShoppingList(
        id: currentState.shoppingList.id,
        name: currentState.shoppingList.name,
        date: currentState.shoppingList.date,
        products: updatedProducts,
      );

      emit(ShoppingListLoaded(
        updatedShoppingList,
        validationErrors: validationErrors,
        invalidProducts: invalidProducts,
      ));
    }
  }

  Future<void> _onRemoveProductFromList(
    RemoveProductFromList event,
    Emitter<ShoppingListState> emit,
  ) async {
    if (state is ShoppingListLoaded) {
      final currentState = state as ShoppingListLoaded;
      
      // Remove the product
      final updatedProducts = currentState.shoppingList.products
          .where((product) => product.id != event.productId)
          .toList();

      // Update invalid products list
      final updatedInvalidProducts = currentState.invalidProducts
          .where((product) => product.id != event.productId)
          .toList();

      // Update validation errors
      final updatedErrors = currentState.validationErrors
          .where((error) => !error.contains(event.productId))
          .toList();

      final updatedShoppingList = ShoppingList(
        id: currentState.shoppingList.id,
        name: currentState.shoppingList.name,
        date: currentState.shoppingList.date,
        products: updatedProducts,
      );

      emit(ShoppingListLoaded(
        updatedShoppingList,
        validationErrors: updatedErrors,
        invalidProducts: updatedInvalidProducts,
      ));
    }
  }

  Future<void> _onValidateShoppingList(
    ValidateShoppingList event,
    Emitter<ShoppingListState> emit,
  ) async {
    if (state is ShoppingListLoaded) {
      final currentState = state as ShoppingListLoaded;
      final validationErrors = <String>[];
      final invalidProducts = <Product>[];

      if (currentShop != null) {
        for (final product in currentState.shoppingList.products) {
          if (!_isRayonValid(product.rayon)) {
            validationErrors.add(
              'Le rayon "${product.rayon}" pour le produit "${product.name}" n\'existe pas dans ce magasin'
            );
            invalidProducts.add(product);
          }
        }
      }

      emit(ShoppingListLoaded(
        currentState.shoppingList,
        validationErrors: validationErrors,
        invalidProducts: invalidProducts,
      ));
    }
  }
}