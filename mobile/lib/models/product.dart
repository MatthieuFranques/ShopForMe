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
  final String rayon;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.rayon,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      return Product(
        id: json['id']?.toString() ?? 'unknown',
        name: json['name']?.toString() ?? 'Unnamed Product',
        category: json['category']?.toString() ?? 'Misc',
        rayon: json['rayon']?.toString() ?? 'Unknown',
      );
    } catch (e) {
      print('❌ Error creating Product from JSON: $e');
      print('❌ Problematic JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'rayon': rayon,
  };

  @override
  String toString() {
    return 'Product(id: $id, name: $name, category: $category, rayon: $rayon)';
  }
}