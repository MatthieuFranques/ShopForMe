import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/models/section.dart'; // Assurez-vous que le chemin d'importation est correct.

void main() {
  group('Section', () {
    // Test de la méthode fromJson
    test('should create a Section from JSON', () {
      final Map<String, dynamic> json = {
        'id': '123',
        'name': 'Electronics',
        'price': 100,
        'storeId': 1,
        'productId': 42,
      };

      final section = Section.fromJson(json);

      expect(section.id, '123');
      expect(section.name, 'Electronics');
      expect(section.price, 100);
      expect(section.storeId, 1);
      expect(section.productId, 42);
    });

    // Test de la méthode toJson
    test('should convert Section to JSON', () {
      final section = Section(
        id: '123',
        name: 'Electronics',
        price: 100,
        storeId: 1,
        productId: 42,
      );

      final Map<String, dynamic> json = section.toJson();

      expect(json['id'], '123');
      expect(json['name'], 'Electronics');
      expect(json['price'], 100);
      expect(json['storeId'], 1);
      expect(json['productId'], 42);
    });

    // Test de la méthode toString
    test('should return a string representation of the Section', () {
      final section = Section(
        id: '123',
        name: 'Electronics',
        price: 100,
        storeId: 1,
        productId: 42,
      );

      final stringRepresentation = section.toString();

      expect(stringRepresentation,
          'Section(id: 123, name: Electronics, price: 100, storeId: 1, productId: 42)');
    });

    // Test de la gestion des valeurs par défaut en cas d'absence de données dans JSON
    test('should handle missing or null values in fromJson', () {
      final Map<String, dynamic> json = {
        'name':
            'Unnamed Section', // Absence de "id", "price", "storeId", "productId"
      };

      final section = Section.fromJson(json);

      expect(section.id, 'unknown');
      expect(section.name, 'Unnamed Section');
      expect(section.price, 1);
      expect(section.storeId, 1);
      expect(section.productId, 1);
    });
  });
}
