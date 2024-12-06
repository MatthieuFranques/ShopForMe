// test/services/store_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/services/cache_service.dart';
import 'package:mobile/services/store_service.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/models/shop.dart'; // Importez Shop et ShopCell depuis shop.dart
import 'dart:convert';
import 'package:mobile/utils/constants.dart'; // Importer constants.dart

import 'store_service_test.mocks.dart';

@GenerateMocks([http.Client, CacheService])
void main() {
  group('StoreService Tests', () {
    late MockCacheService mockCacheService;
    late MockClient mockHttpClient;
    late StoreService storeService;

    setUp(() {
      mockCacheService = MockCacheService();
      mockHttpClient = MockClient();
      storeService = StoreService(mockCacheService, client: mockHttpClient);
    });

    test('getProducts should return cached products if available', () async {
      final cachedProducts = [
        Product(id: 'p1', name: 'Apple', category: 'Fruits', rayon: 'Fruits'),
      ];

      when(mockCacheService.getProducts('all')).thenReturn(cachedProducts);

      final products = await storeService.getProducts();

      expect(products, equals(cachedProducts));
      verify(mockCacheService.getProducts('all')).called(1);
      verifyNever(mockHttpClient.get(any, headers: anyNamed('headers')));
    });

    test('getProducts should fetch from API and cache if cache is empty', () async {
      when(mockCacheService.getProducts('all')).thenReturn(null);

      final apiResponse = {
        'products': [
          {'id': 'p1', 'name': 'Apple', 'category': 'Fruits', 'rayon': 'Fruits'},
          {'id': 'p2', 'name': 'Carrot', 'category': 'Légumes', 'rayon': 'Légumes'},
        ]
      };

      when(mockHttpClient.get(
        Uri.parse('$baseUrl/product'),
        headers: anyNamed('headers'),
      )).thenAnswer(
        (_) async => http.Response(jsonEncode(apiResponse), 200),
      );

      final products = await storeService.getProducts();

      expect(products.length, equals(2));
      expect(products[0].name, equals('Apple'));
      expect(products[1].category, equals('Légumes'));

      verify(mockCacheService.getProducts('all')).called(1);
      verify(mockHttpClient.get(
        Uri.parse('$baseUrl/product'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      )).called(1);
      verify(mockCacheService.cacheProducts('all', products)).called(1);
    });

    test('getProducts should throw exception on HTTP error and use cache if available', () async {
      when(mockCacheService.getProducts('all')).thenReturn(null);

      when(mockHttpClient.get(
        Uri.parse('$baseUrl/product'),
        headers: anyNamed('headers'),
      )).thenAnswer(
        (_) async => http.Response('Internal Server Error', 500),
      );

      expect(
        () async => await storeService.getProducts(),
        throwsException,
      );

      verify(mockCacheService.getProducts('all')).called(1);
      verify(mockHttpClient.get(
        Uri.parse('$baseUrl/product'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      )).called(1);
      verifyNever(mockCacheService.cacheProducts(any, any));
    });

    test('loadCurrentShop should set currentShop from cache if available', () async {
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

      when(mockCacheService.getShop(1)).thenReturn(shop);

      await storeService.loadCurrentShop(1);

      expect(storeService.currentShop, equals(shop));
      verify(mockCacheService.getShop(1)).called(1);
    });

    test('loadCurrentShop should not set currentShop if not in cache', () async {
      when(mockCacheService.getShop(1)).thenReturn(null);

      await storeService.loadCurrentShop(1);

      expect(storeService.currentShop, isNull);
    verify(mockCacheService.getShop(1)).called(1);
    });
    
    test('set currentShop should update the current shop', () {
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

      storeService.currentShop = shop;

      expect(storeService.currentShop, equals(shop));
    });

    test('getProducts should return cached products after error if available', () async {
      final cachedProducts = [
        Product(id: 'p1', name: 'Banana', category: 'Fruits', rayon: 'Fruits'),
      ];

      int cacheCallCount = 0;
      when(mockCacheService.getProducts('all')).thenAnswer((_) {
        cacheCallCount++;
        if (cacheCallCount == 1) {
          return null;
        } else {
          return cachedProducts;
        }
      });

      when(mockHttpClient.get(
        Uri.parse('$baseUrl/product'),
        headers: anyNamed('headers'),
      )).thenThrow(Exception('Network Error'));

      final products = await storeService.getProducts();

      expect(products.length, equals(1));
      expect(products[0].name, equals('Banana'));

      expect(cacheCallCount, equals(2));

      verify(mockCacheService.getProducts('all')).called(2);
      verify(mockHttpClient.get(
        Uri.parse('$baseUrl/product'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      )).called(1);
      verifyNever(mockCacheService.cacheProducts(any, any));
    });
  });

}