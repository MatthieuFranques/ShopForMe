// test/services/cache_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:mobile/models/shop.dart'; // Importez Shop et ShopCell depuis shop.dart
import 'package:mobile/models/product.dart';
import 'package:mobile/services/cache_service.dart';

void main() {
  group('CacheService Tests', () {
    late CacheService cacheService;

    setUp(() async {
      await setUpTestHive(); // Initialise Hive pour les tests
      cacheService = CacheService();
      await cacheService.init();
    });

    tearDown(() async {
      await tearDownTestHive(); // Nettoie Hive après les tests
    });

    test('cacheShop should store a shop correctly', () async {
      final shop = Shop(
        id: 1,
        name: 'Magasin Test',
        ville: 'Paris',
        adresse: '123 Rue de Exemple',
        layout: [
          [
            ShopCell(
              name: 'Fruits',
              size: 2,
              type: 'RAYON',
              isBeacon: false,
            ),
            ShopCell(
              name: 'Légumes',
              size: 3,
              type: 'RAYON',
              isBeacon: false,
            ),
          ],
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        deletedAt: null,
      );

      await cacheService.cacheShop(shop);

      final retrievedShop = cacheService.getShop(1);
      expect(retrievedShop, isNotNull);
      expect(retrievedShop!.id, equals(shop.id));
      expect(retrievedShop.name, equals(shop.name));
      expect(retrievedShop.ville, equals(shop.ville));
      expect(retrievedShop.adresse, equals(shop.adresse));
      expect(retrievedShop.layout.length, equals(shop.layout.length));
      expect(retrievedShop.layout[0].length, equals(shop.layout[0].length));
      expect(retrievedShop.layout[0][0].name, equals('Fruits'));
    });

    test('getShop should return null if shop not found', () {
      final retrievedShop = cacheService.getShop(999);
      expect(retrievedShop, isNull);
    });

    test('cacheProducts should store products correctly', () async {
      final products = [
        Product(id: 'p1', name: 'Apple', category: 'Fruits', rayon: 'Fruits'),
        Product(id: 'p2', name: 'Carrot', category: 'Légumes', rayon: 'Légumes'),
      ];

      await cacheService.cacheProducts('all', products);

      final retrievedProducts = cacheService.getProducts('all');
      expect(retrievedProducts, isNotNull);
      expect(retrievedProducts!.length, equals(products.length));
      expect(retrievedProducts[0].name, equals('Apple'));
      expect(retrievedProducts[1].category, equals('Légumes'));
    });

    test('getProducts should return null if key not found', () {
      final retrievedProducts = cacheService.getProducts('nonexistent_key');
      expect(retrievedProducts, isNull);
    });

    test('clearCache should remove all data', () async {
      final shop = Shop(
        id: 1,
        name: 'Magasin Test',
        ville: 'Paris',
        adresse: '123 Rue de Exemple',
        layout: [
          [
            ShopCell(
              name: 'Fruits',
              size: 2,
              type: 'RAYON',
              isBeacon: false,
            ),
          ],
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        deletedAt: null,
      );

      final products = [
        Product(id: 'p1', name: 'Apple', category: 'Fruits', rayon: 'Fruits'),
      ];

      await cacheService.cacheShop(shop);
      await cacheService.cacheProducts('all', products);

      await cacheService.clearCache();

      final retrievedShop = cacheService.getShop(1);
      final retrievedProducts = cacheService.getProducts('all');

      expect(retrievedShop, isNull);
      expect(retrievedProducts, isNull);
    });
  });
}
