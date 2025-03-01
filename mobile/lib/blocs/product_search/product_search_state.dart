import 'package:equatable/equatable.dart';
import 'package:mobile/models/product.dart';

abstract class ProductSearchState extends Equatable {
  const ProductSearchState();
  
  @override
  List<Object> get props => [];
}

class ProductSearchInitial extends ProductSearchState {}

class ProductSearchLoading extends ProductSearchState {}

class ProductSearchLoaded extends ProductSearchState {
  final List<Product> products;
  final List<Product> filteredProducts;
  final String currentQuery;

  const ProductSearchLoaded({
    required this.products,
    required this.filteredProducts,
    this.currentQuery = '',
  });

  @override
  List<Object> get props => [products, filteredProducts, currentQuery];
}

class ProductSearchError extends ProductSearchState {
  final String message;
  const ProductSearchError(this.message);

  @override
  List<Object> get props => [message];
}