import 'package:mobile/models/product.dart';
import 'package:mobile/models/shop.dart';
import 'package:mobile/services/store_service.dart';

class LocationProductService {
  final StoreService _storeService;

  LocationProductService(this._storeService);

  /// Trouve la position d'un produit dans la matrice du magasin
  /// @param product Le produit dont on cherche la position
  /// @returns Liste [x, y] représentant la position dans la matrice
  Future<List<int>> getProductPosition(Product product) async {
    final Shop? currentShop = _storeService.currentShop;

    if (currentShop == null) {
      throw Exception('Aucun magasin sélectionné');
    }

    // Parcourir la matrice du magasin
    for (int i = 0; i < currentShop.layout.length; i++) {
      for (int j = 0; j < currentShop.layout[i].length; j++) {
        final ShopCell cell = currentShop.layout[i][j];
        // Si la cellule correspond au rayon du produit
        if (cell.type == "RAYON" && cell.name == product.rayon) {
          return [i, j];
        }
      }
    }

    throw Exception('Position du produit non trouvée');
  }
}
