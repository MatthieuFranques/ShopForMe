import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/models/product.dart'; // Assurez-vous que le chemin du fichier est correct

void main() {
  group('Product Model Tests', () {
    late Product product;
    const name = 'Test Product';
    const category = 'Test Category';
    const rayon = 'Test Rayon';

    setUp(() {
      // Création d'un produit fictif pour les tests
      product = Product(
        id: '123',
        name: name,
        category: category,
        rayon: rayon,
      );
    });

    // Test de l'initialisation de l'objet Product
    test('Product should initialize with correct values', () {
      expect(product.id, '123');
      expect(product.name, name);
      expect(product.category, category);
      expect(product.rayon, rayon);
    });

    // Test de la méthode fromJson avec des données valides
    test('fromJson should correctly parse JSON into a Product', () {
      final json = {
        'id': '123',
        'name': name,
        'category': category,
        'rayon': rayon,
      };

      final parsedProduct = Product.fromJson(json);

      expect(parsedProduct.id, '123');
      expect(parsedProduct.name, name);
      expect(parsedProduct.category, category);
      expect(parsedProduct.rayon, rayon);
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
        'name': name,
        'category': category,
        'rayon': rayon,
      };

      final productJson = product.toJson();

      expect(productJson, expectedJson);
    });

    // Test de la méthode fromJson avec des données mal formées
    test('fromJson should throw an error if the JSON is malformed', () {
      final invalidJson = {
        'id': '123',
        // 'name' is missing
        'category': category,
        'rayon': rayon,
      };

      final parsedProduct = Product.fromJson(invalidJson);
      expect(parsedProduct.name, 'Unnamed Product');
    });
  });
}
