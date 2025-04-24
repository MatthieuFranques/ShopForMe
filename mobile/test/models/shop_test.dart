import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/models/shop.dart'; // Assurez-vous que le chemin du fichier est correct

void main() {
  group('Shop and ShopCell Model Tests', () {
    late Shop shop;
    late ShopCell shopCell;
    const name1 = 'Aisle 1';
    const name2 = 'Aisle 2';
    const type = 'Product Display';
    const shopName = 'Test Shop';
    const shopCity = 'Test Ville';
    const shopAddress = 'Test Address';


    setUp(() {
      // Initialiser un ShopCell et un Shop fictifs pour les tests
      shopCell = ShopCell(
        name: name1,
        size: 10,
        type: type,
        isBeacon: true,
      );

      shop = Shop(
        id: 1,
        name: shopName,
        ville: shopCity,
        adresse: shopAddress,
        layout: [
          [
            shopCell,
            shopCell,
          ],
        ],
      );
    });

    // Test de l'initialisation de l'objet Shop
    test('Shop should initialize with correct values', () {
      expect(shop.id, 1);
      expect(shop.name, shopName);
      expect(shop.ville, shopCity);
      expect(shop.adresse, shopAddress);
      expect(shop.layout.length, 1);
      expect(shop.layout[0].length,
          2); // On vérifie que le layout contient deux éléments
    });

    // Test de la méthode fromJson pour Shop
    test('fromJson should correctly parse JSON into a Shop', () {
      final json = {
        'id': 1,
        'name': shopName,
        'ville': shopCity,
        'adresse': shopAddress,
        'layout': [
          [
            {
              'name': name1,
              'size': 10,
              'type': type,
              'isBeacon': true
            },
            {
              'name': name2,
              'size': 15,
              'type': type,
              'isBeacon': false
            }
          ],
        ],
      };

      final parsedShop = Shop.fromJson(json);

      expect(parsedShop.id, 1);
      expect(parsedShop.name, shopName);
      expect(parsedShop.ville, shopCity);
      expect(parsedShop.adresse, shopAddress);
      expect(parsedShop.layout[0].length,
          2); // On s'assure que le layout contient deux éléments
      expect(parsedShop.layout[0][0].name,
          name1); // Vérifier le premier élément de la liste
      expect(parsedShop.layout[0][1].isBeacon,
          false); // Vérifier la valeur 'isBeacon' du second élément
    });

    // Test de la méthode toJson pour Shop
    test('toJson should correctly convert a Shop to JSON', () {
      final expectedJson = {
        'id': 1,
        'name': shopName,
        'ville': shopCity,
        'adresse': shopAddress,
        'layout': [
          [
            {
              'name': name1,
              'size': 10,
              'type': type,
              'isBeacon': true
            },
            {
              'name': name1,
              'size': 10,
              'type': type,
              'isBeacon': true
            }
          ],
        ],
      };

      final shopJson = shop.toJson();

      expect(shopJson, expectedJson);
    });

    // Test de la méthode fromJson pour ShopCell
    test('fromJson should correctly parse JSON into a ShopCell', () {
      final json = {
        'name': name1,
        'size': 10,
        'type': type,
        'isBeacon': true,
      };

      final parsedShopCell = ShopCell.fromJson(json);

      expect(parsedShopCell.name, name1);
      expect(parsedShopCell.size, 10);
      expect(parsedShopCell.type, type);
      expect(parsedShopCell.isBeacon, true);
    });

    // Test de la méthode toJson pour ShopCell
    test('toJson should correctly convert a ShopCell to JSON', () {
      final expectedJson = {
        'name': name1,
        'size': 10,
        'type': type,
        'isBeacon': true,
      };

      final shopCellJson = shopCell.toJson();

      expect(shopCellJson, expectedJson);
    });
  });
}
