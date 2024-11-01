import 'package:mobile/models/product.dart';
class ShoppingList {
  final String id;
  final String name;
  final String date;
  final List<Product> products;

  ShoppingList({
    required this.id,
    required this.name,
    required this.date,
    required this.products,
  });

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    return ShoppingList(
      id: json['id'] ?? 0, 
      name: json['name'] ?? 'Unnamed List',  
      date: json['date'] ?? 'Unknown Date',  
      products: (json['products'] as List<dynamic>).map((productJson) {
        return Product.fromJson(productJson);
      }).toList(),
    );
  }
}
