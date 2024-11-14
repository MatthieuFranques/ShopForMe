import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 2)
class Product extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final List<int> layout;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.layout,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? 'unknown',
      name: json['name'] ?? 'Unnamed Product',
      category: json['category'] ?? 'Misc',
      layout: List<int>.from(json['layout'] ?? [0, 0]),
    );
  }
}