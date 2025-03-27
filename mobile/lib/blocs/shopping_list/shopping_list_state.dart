import 'package:equatable/equatable.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/models/shopping_list.dart';

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