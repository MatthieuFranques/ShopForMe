// shopping_lists_collection.dart
import 'package:mobile/models/shopping_list.dart';

class ShoppingListsCollection {
  final List<ShoppingList> lists;
  final int currentIndex;

  ShoppingListsCollection({
    required this.lists,
    this.currentIndex = 0,
  });

  factory ShoppingListsCollection.fromJson(Map<String, dynamic> json) {
    final lists = (json['lists'] as List<dynamic>)
        .map((listJson) => ShoppingList.fromJson(listJson))
        .toList();
    
    return ShoppingListsCollection(
      lists: lists,
      currentIndex: json['currentIndex'] ?? 0,
    );
  }

  ShoppingListsCollection copyWith({
    List<ShoppingList>? lists,
    int? currentIndex,
  }) {
    return ShoppingListsCollection(
      lists: lists ?? this.lists,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}