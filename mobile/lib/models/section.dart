import 'package:hive/hive.dart';

part 'section.g.dart';

@HiveType(typeId: 3)
class Section extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int price;

  @HiveField(3)
  final int storeId;

  @HiveField(4)
  final int productId;

  Section({
    required this.id,
    required this.name,
    required this.price,
    required this.storeId,
    required this.productId
  });


  factory Section.fromJson(Map<String, dynamic> json) {
    try {
      return Section(
        id: json['id']?.toString() ?? 'unknown',
        name: json['name']?.toString() ?? 'Unnamed Section',
        price: json['price'] ?? 1,
        storeId: json['storeId'] ?? 1,
        productId: json['productId'] ?? 1
      );
    } catch (e) {
      print('❌ Error creating Section from JSON: $e');
      print('❌ Problematic JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'storeId': storeId,
    'productId': productId
  };

  @override
  String toString() {
    return 'Section(id: $id, name: $name, price: $price, storeId: $storeId, productId: $productId)';
  }
}