import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/models/product.dart'; // Assurez-vous que le chemin du fichier est correct
import 'package:mobile/models/shopping_list.dart';

void main() {
  group('ShoppingList Model Tests', () {
    late ShoppingList shoppingList;
    late Product product1;
    late Product product2;

    setUp(() {
      // Création de produits fictifs pour les tests
      product1 = Product(
        id: '1',
        name: 'Product 1',
        category: 'Category 1',
        rayon: 'Rayon A',
      );
      product2 = Product(
        id: '2',
        name: 'Product 2',
        category: 'Category 2',
        rayon: 'Rayon B',
      );

      // Création de la ShoppingList avec des produits fictifs
      shoppingList = ShoppingList(
        id: '123',
        name: 'My Shopping List',
        date: '2025-03-21',
        products: [product1, product2],
      );
    });

    // Test de l'initialisation de la ShoppingList
    test('ShoppingList should initialize with correct values', () {
      expect(shoppingList.id, '123');
      expect(shoppingList.name, 'My Shopping List');
      expect(shoppingList.date, '2025-03-21');
      expect(shoppingList.products, [product1, product2]);
    });

    // Test de la méthode fromJson
    test('fromJson should correctly parse JSON into a ShoppingList', () {
      final json = {
        'id': '123',
        'name': 'My Shopping List',
        'date': '2025-03-21',
        'products': [
          {
            'id': '1',
            'name': 'Product 1',
            'category': 'Category 1',
            'rayon': 'Rayon A'
          },
          {
            'id': '2',
            'name': 'Product 2',
            'category': 'Category 2',
            'rayon': 'Rayon B'
          }
        ]
      };

      final parsedShoppingList = ShoppingList.fromJson(json);

      expect(parsedShoppingList.id, '123');
      expect(parsedShoppingList.name, 'My Shopping List');
      expect(parsedShoppingList.date, '2025-03-21');
      expect(parsedShoppingList.products.length, 2);
      expect(parsedShoppingList.products[0].name, 'Product 1');
      expect(parsedShoppingList.products[1].rayon, 'Rayon B');
    });

    // Test si la méthode fromJson fonctionne avec des valeurs par défaut
    test('fromJson should handle missing fields with default values', () {
      final json = {
        'id': '456',
        // 'name' est omis
        // 'date' est omis
        'products': [
          {
            'id': '1',
            'name': 'Product 1',
            'category': 'Category 1',
            'rayon': 'Rayon A'
          }
        ]
      };

      final parsedShoppingList = ShoppingList.fromJson(json);

      expect(parsedShoppingList.id, '456');
      expect(parsedShoppingList.name, 'Unnamed List'); // Valeur par défaut
      expect(parsedShoppingList.date, 'Unknown Date'); // Valeur par défaut
      expect(parsedShoppingList.products.length, 1);
      expect(parsedShoppingList.products[0].name, 'Product 1');
    });

    // Test si la méthode fromJson gère les valeurs nulles dans le JSON
    test('fromJson should handle null values gracefully', () {
      final json = {'id': null, 'name': null, 'date': null, 'products': null};

      final parsedShoppingList = ShoppingList.fromJson(json);

      expect(parsedShoppingList.id, 'unknown'); // Valeur par défaut
      expect(parsedShoppingList.name, 'Unnamed List'); // Valeur par défaut
      expect(parsedShoppingList.date, 'Unknown Date'); // Valeur par défaut
      expect(parsedShoppingList.products, []); // Liste vide par défaut
    });
  });
}
