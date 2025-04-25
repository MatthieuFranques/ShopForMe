import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/models/product.dart'; // Assurez-vous que le chemin du fichier est correct
import 'package:mobile/models/shopping_list.dart';

void main() {
  group('ShoppingList Model Tests', () {
    late ShoppingList shoppingList;
    late Product product1;
    late Product product2;
    const String id = '123';
    const String date = '2025-03-21';
    const String name = 'My Shopping List';
    const String rayonP1 = 'Rayon A';
    const String rayonP2 = 'Rayon B';
    const String categoryP1 = 'Category 1';
    const String categoryP2 = 'Category 2';
    const String productP1 = 'Product 1';
    const String productP2 = 'Product 2';

    setUp(() {
      // Création de produits fictifs pour les tests
      product1 = Product(
        id: '1',
        name: productP1,
        category: categoryP1,
        rayon: rayonP1,
      );
      product2 = Product(
        id: '2',
        name: productP2,
        category: categoryP2,
        rayon: rayonP2,
      );

      // Création de la ShoppingList avec des produits fictifs
      shoppingList = ShoppingList(
        id: id,
        name: name,
        date: date,
        products: [product1, product2],
      );
    });

    // Test de l'initialisation de la ShoppingList
    test('ShoppingList should initialize with correct values', () {
      expect(shoppingList.id, id);
      expect(shoppingList.name, name);
      expect(shoppingList.date, date);
      expect(shoppingList.products, [product1, product2]);
    });

    // Test de la méthode fromJson
    test('fromJson should correctly parse JSON into a ShoppingList', () {
      final json = {
        'id': id,
        'name': name,
        'date': date,
        'products': [
          {
            'id': '1',
            'name': productP1,
            'category': categoryP1,
            'rayon': rayonP1
          },
          {
            'id': '2',
            'name': productP2,
            'category': categoryP2,
            'rayon': rayonP2
          }
        ]
      };

      final parsedShoppingList = ShoppingList.fromJson(json);

      expect(parsedShoppingList.id, id);
      expect(parsedShoppingList.name, name);
      expect(parsedShoppingList.date, date);
      expect(parsedShoppingList.products.length, 2);
      expect(parsedShoppingList.products[0].name, productP1);
      expect(parsedShoppingList.products[1].rayon, rayonP2);
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
            'name': productP1,
            'category': categoryP1,
            'rayon': rayonP1
          }
        ]
      };

      final parsedShoppingList = ShoppingList.fromJson(json);

      expect(parsedShoppingList.id, '456');
      expect(parsedShoppingList.name, 'Unnamed List'); // Valeur par défaut
      expect(parsedShoppingList.date, 'Unknown Date'); // Valeur par défaut
      expect(parsedShoppingList.products.length, 1);
      expect(parsedShoppingList.products[0].name, productP1);
    });

    // Test si la méthode fromJson gère les valeurs nulles dans le JSON
    test('fromJson should handle null values gracefully', () {
      final json = {'id': null, 'name': null, 'date': null, 'products': []};

      final parsedShoppingList = ShoppingList.fromJson(json);

      expect(parsedShoppingList.id, 'unknown'); // Valeur par défaut
      expect(parsedShoppingList.name, 'Unnamed List'); // Valeur par défaut
      expect(parsedShoppingList.date, 'Unknown Date'); // Valeur par défaut
      expect(parsedShoppingList.products, []); // Liste vide par défaut
    });
  });
}
