import 'package:equatable/equatable.dart';
import 'package:mobile/models/product.dart';


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