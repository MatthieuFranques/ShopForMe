// shop.dart
import 'package:hive/hive.dart';

part 'shop.g.dart';

@HiveType(typeId: 0)
class Shop extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String ville;

  @HiveField(3)
  final String adresse;

  @HiveField(4)
  final List<List<ShopCell>> layout;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  @HiveField(7)
  final DateTime? deletedAt;

  Shop({
    required this.id,
    required this.name,
    required this.ville,
    required this.adresse,
    required this.layout,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      name: json['name'],
      ville: json['ville'],
      adresse: json['adresse'],
      layout: (json['layout'] as List)
          .map((row) => (row as List)
              .map((cell) => ShopCell.fromJson(cell))
              .toList())
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt: json['deletedAt'] != null 
          ? DateTime.parse(json['deletedAt'])
          : null,
    );
  }
}

@HiveType(typeId: 1)
class ShopCell extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int size;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final bool isBeacon;

  ShopCell({
    required this.name,
    required this.size,
    required this.type,
    required this.isBeacon,
  });

  factory ShopCell.fromJson(Map<String, dynamic> json) {
    return ShopCell(
      name: json['name'],
      size: json['size'],
      type: json['type'],
      isBeacon: json['isBeacon'],
    );
  }
}