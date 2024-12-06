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

class SelectShoppingList extends ShoppingListEvent {
  final String listId;
  SelectShoppingList(this.listId);
  
  @override
  List<Object?> get props => [listId];
}

class CreateNewShoppingList extends ShoppingListEvent {}

class ValidateShoppingList extends ShoppingListEvent {}

class DeleteShoppingList extends ShoppingListEvent {
  final String listId;
  DeleteShoppingList(this.listId);

  @override
  List<Object?> get props => [listId];
}

// States
abstract class ShoppingListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShoppingListLoading extends ShoppingListState {}

class ShoppingListLoaded extends ShoppingListState {
  final List<ShoppingList> shoppingLists;
  final ShoppingList currentList;
  final List<String> validationErrors;
  final List<Product> invalidProducts;

  ShoppingListLoaded(
    this.shoppingLists,
    this.currentList, {
    this.validationErrors = const [],
    this.invalidProducts = const [],
  });

  @override
  List<Object?> get props => [shoppingLists, currentList, validationErrors, invalidProducts];
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
    on<SelectShoppingList>(_onSelectShoppingList);
    on<CreateNewShoppingList>(_onCreateNewShoppingList);
    on<DeleteShoppingList>(_onDeleteShoppingList);
  }

  Future<List<ShoppingList>> _loadShoppingListsFromAssets() async {
    try {
      final jsonString = await rootBundle.loadString('assets/list/defaultShoppingList.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> listsData = jsonData['lists'];
      return listsData.map((listData) => ShoppingList.fromJson(listData)).toList();
    } catch (e) {
      print('Error loading shopping lists: $e');
      throw Exception('Failed to load shopping lists: $e');
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
      final shoppingLists = await _loadShoppingListsFromAssets();
      if (shoppingLists.isEmpty) {
        emit(ShoppingListError('Aucune liste de courses trouvée'));
        return;
      }

      final currentList = shoppingLists.first;
      final validationErrors = <String>[];
      final invalidProducts = <Product>[];

      // Validate each product's rayon if we have a shop
      if (currentShop != null) {
        for (final product in currentList.products) {
          if (!_isRayonValid(product.rayon)) {
            validationErrors.add(
              'Le rayon "${product.rayon}" pour le produit "${product.name}" n\'existe pas dans ce magasin'
            );
            invalidProducts.add(product);
          }
        }
      }

      emit(ShoppingListLoaded(
        shoppingLists,
        currentList,
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

      final updatedProducts = List<Product>.from(currentState.currentList.products)
        ..add(event.product);

      final updatedList = ShoppingList(
        id: currentState.currentList.id,
        name: currentState.currentList.name,
        date: currentState.currentList.date,
        products: updatedProducts,
      );

      final updatedLists = currentState.shoppingLists.map((list) =>
        list.id == updatedList.id ? updatedList : list
      ).toList();

      emit(ShoppingListLoaded(
        updatedLists,
        updatedList,
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
      final updatedProducts = currentState.currentList.products
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

      final updatedList = ShoppingList(
        id: currentState.currentList.id,
        name: currentState.currentList.name,
        date: currentState.currentList.date,
        products: updatedProducts,
      );

      final updatedLists = currentState.shoppingLists.map((list) =>
        list.id == updatedList.id ? updatedList : list
      ).toList();

      emit(ShoppingListLoaded(
        updatedLists,
        updatedList,
        validationErrors: updatedErrors,
        invalidProducts: updatedInvalidProducts,
      ));
    }
  }

  Future<void> _onSelectShoppingList(
    SelectShoppingList event,
    Emitter<ShoppingListState> emit,
  ) async {
    if (state is ShoppingListLoaded) {
      final currentState = state as ShoppingListLoaded;
      final selectedList = currentState.shoppingLists
          .firstWhere((list) => list.id == event.listId);
      
      final validationErrors = <String>[];
      final invalidProducts = <Product>[];

      if (currentShop != null) {
        for (final product in selectedList.products) {
          if (!_isRayonValid(product.rayon)) {
            validationErrors.add(
              'Le rayon "${product.rayon}" pour le produit "${product.name}" n\'existe pas dans ce magasin'
            );
            invalidProducts.add(product);
          }
        }
      }

      emit(ShoppingListLoaded(
        currentState.shoppingLists,
        selectedList,
        validationErrors: validationErrors,
        invalidProducts: invalidProducts,
      ));
    }
  }

Future<void> _onDeleteShoppingList(
    DeleteShoppingList event,
    Emitter<ShoppingListState> emit,
  ) async {
    if (state is ShoppingListLoaded) {
      final currentState = state as ShoppingListLoaded;
      
      // Vérifier s'il reste plus d'une liste
      if (currentState.shoppingLists.length <= 1) {
        emit(ShoppingListError('Impossible de supprimer la dernière liste'));
        return;
      }

      // Filtrer la liste à supprimer
      final updatedLists = currentState.shoppingLists
          .where((list) => list.id != event.listId)
          .toList();

      // Sélectionner la première liste comme liste courante si la liste supprimée était la liste courante
      final newCurrentList = currentState.currentList.id == event.listId
          ? updatedLists.first
          : currentState.currentList;

      // Vérifier la validité des produits de la nouvelle liste courante
      final validationErrors = <String>[];
      final invalidProducts = <Product>[];

      if (currentShop != null) {
        for (final product in newCurrentList.products) {
          if (!_isRayonValid(product.rayon)) {
            validationErrors.add(
              'Le rayon "${product.rayon}" pour le produit "${product.name}" n\'existe pas dans ce magasin'
            );
            invalidProducts.add(product);
          }
        }
      }

      emit(ShoppingListLoaded(
        updatedLists,
        newCurrentList,
        validationErrors: validationErrors,
        invalidProducts: invalidProducts,
      ));
    }
  }


  Future<void> _onCreateNewShoppingList(
    CreateNewShoppingList event,
    Emitter<ShoppingListState> emit,
  ) async {
    if (state is ShoppingListLoaded) {
      final currentState = state as ShoppingListLoaded;
      final newList = ShoppingList(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: "Nouvelle liste",
        date: DateTime.now().toString(),
        products: [],
      );
      
      final updatedLists = List<ShoppingList>.from(currentState.shoppingLists)
        ..add(newList);
      
      emit(ShoppingListLoaded(
        updatedLists,
        newList,
        validationErrors: const [],
        invalidProducts: const [],
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
        for (final product in currentState.currentList.products) {
          if (!_isRayonValid(product.rayon)) {
            validationErrors.add(
              'Le rayon "${product.rayon}" pour le produit "${product.name}" n\'existe pas dans ce magasin'
            );
            invalidProducts.add(product);
          }
        }
      }

      emit(ShoppingListLoaded(
        currentState.shoppingLists,
        currentState.currentList,
        validationErrors: validationErrors,
        invalidProducts: invalidProducts,
      ));
    }
  }
}