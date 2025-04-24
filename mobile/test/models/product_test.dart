import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/models/product.dart'; // Assurez-vous que le chemin du fichier est correct

void main() {
  group('Product Model Tests', () {
    late Product product;

    setUp(() {
      // Création d'un produit fictif pour les tests
      product = Product(
        id: '123',
        name: 'Test Product',
        category: 'Test Category',
        rayon: 'Test Rayon',
      );
    });

    // Test de l'initialisation de l'objet Product
    test('Product should initialize with correct values', () {
      expect(product.id, '123');
      expect(product.name, 'Test Product');
      expect(product.category, 'Test Category');
      expect(product.rayon, 'Test Rayon');
    });

    // Test de la méthode fromJson avec des données valides
    test('fromJson should correctly parse JSON into a Product', () {
      final json = {
        'id': '123',
        'name': 'Test Product',
        'category': 'Test Category',
        'rayon': 'Test Rayon',
      };

      final parsedProduct = Product.fromJson(json);

      expect(parsedProduct.id, '123');
      expect(parsedProduct.name, 'Test Product');
      expect(parsedProduct.category, 'Test Category');
      expect(parsedProduct.rayon, 'Test Rayon');
    });

    // Test de la méthode fromJson avec des données manquantes ou nulles
    test('fromJson should handle missing or null fields gracefully', () {
      final json = {
        'id': null,
        'name': null,
        'category': null,
        'rayon': null,
      };

      final parsedProduct = Product.fromJson(json);

      expect(parsedProduct.id, 'unknown'); // Valeur par défaut
      expect(parsedProduct.name, 'Unnamed Product'); // Valeur par défaut
      expect(parsedProduct.category, 'Misc'); // Valeur par défaut
      expect(parsedProduct.rayon, 'Unknown'); // Valeur par défaut
    });

    // Test de la méthode toJson pour vérifier la conversion de Product en JSON
    test('toJson should correctly convert a Product to JSON', () {
      final expectedJson = {
        'id': '123',
        'name': 'Test Product',
        'category': 'Test Category',
        'rayon': 'Test Rayon',
      };

      final productJson = product.toJson();

      expect(productJson, expectedJson);
    });

    // Test de la méthode fromJson avec des données mal formées
    test('fromJson should throw an error if the JSON is malformed', () {
      final invalidJson = {
        'id': '123',
        // 'name' is missing
        'category': 'Test Category',
        'rayon': 'Test Rayon',
      };

      // Nous attendons une exception pour JSON mal formé
      expect(() => Product.fromJson(invalidJson), throwsA(isA<TypeError>()));
    });
  });
}
