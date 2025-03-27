import 'package:mobile/models/product.dart';

abstract class NavigationEvent {}

class LoadNavigationEvent extends NavigationEvent {
  final List<Product> products;
  LoadNavigationEvent({required this.products});
}

class UpdateNavigationEvent extends NavigationEvent {
  final Product product;
  UpdateNavigationEvent({required this.product});
}

class ProductFoundEvent extends NavigationEvent {
  final Product product;
  ProductFoundEvent({required this.product});
}

class UpdatePositionEvent extends NavigationEvent {
  final Product currentProduct;
  UpdatePositionEvent(this.currentProduct);
}

class UpdateNavigationEventDataRow extends NavigationEvent {
  final String decodedData;
  UpdateNavigationEventDataRow(this.decodedData);
}
