import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/models/shopping_list.dart';

Future<ShoppingList> loadShoppingListFromJson() async {
  try {
    final jsonString = await rootBundle.loadString('assets/datas.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    return ShoppingList.fromJson(jsonData);
  } catch (e) {
    print('Error loading shopping list: $e');
    throw Exception('Failed to load shopping list: $e');
  }
}

// ShoppingList Event
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

// ShoppingList State
abstract class ShoppingListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShoppingListLoading extends ShoppingListState {}

class ShoppingListLoaded extends ShoppingListState {
  final ShoppingList shoppingList;

  ShoppingListLoaded(this.shoppingList);

  @override
  List<Object?> get props => [shoppingList];
}

class ShoppingListError extends ShoppingListState {}

// ShoppingList BLoC
class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  ShoppingListBloc() : super(ShoppingListLoading()) {
    on<LoadShoppingList>(_onLoadShoppingList);
    on<AddProductToShoppingList>(_onAddProductToShoppingList);
  }

  void _onLoadShoppingList(LoadShoppingList event, Emitter<ShoppingListState> emit) async {
    emit(ShoppingListLoading()); 

    try {
      final shoppingList = await loadShoppingListFromJson();
      emit(ShoppingListLoaded(shoppingList));
    } catch (error) {
      emit(ShoppingListError());
      print('Failed to load shopping list: $error'); 
    }
  }

  void _onAddProductToShoppingList(AddProductToShoppingList event, Emitter<ShoppingListState> emit) {
    if (state is ShoppingListLoaded) {
      final currentState = state as ShoppingListLoaded;
      final updatedProducts = List<Product>.from(currentState.shoppingList.products)
        ..add(event.product);

      final updatedShoppingList = ShoppingList(
        id: currentState.shoppingList.id,
        name: currentState.shoppingList.name,
        date: currentState.shoppingList.date,
        products: updatedProducts,
      );

      emit(ShoppingListLoaded(updatedShoppingList));
    }
  }
}
