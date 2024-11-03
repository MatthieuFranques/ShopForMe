import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../services/store_service.dart';
import '../models/product.dart';

// Events
abstract class ProductSearchEvent extends Equatable {
  const ProductSearchEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductSearchEvent {}

class SearchProducts extends ProductSearchEvent {
  final String query;
  const SearchProducts(this.query);

  @override
  List<Object> get props => [query];
}

// States
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

// BLoC
class ProductSearchBloc extends Bloc<ProductSearchEvent, ProductSearchState> {
  final StoreService _storeService;
  List<Product> _allProducts = [];

  ProductSearchBloc(this._storeService) : super(ProductSearchInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductSearchState> emit,
  ) async {
    emit(ProductSearchLoading());
    try {
      print('🔄 Loading products');
      final products = await _storeService.getProducts();
      _allProducts = products;
      print('✅ Loaded ${products.length} products');
      
      emit(ProductSearchLoaded(
        products: products,
        filteredProducts: products,
      ));
    } catch (e) {
      print('❌ Error loading products: $e');
      emit(ProductSearchError('Impossible de charger les produits. Veuillez réessayer.'));
    }
  }

  void _onSearchProducts(
    SearchProducts event,
    Emitter<ProductSearchState> emit,
  ) {
    if (_allProducts.isEmpty) {
      emit(const ProductSearchError('Aucun produit disponible'));
      return;
    }

    print('🔍 Searching for: ${event.query}');
    
    if (event.query.isEmpty) {
      emit(ProductSearchLoaded(
        products: _allProducts,
        filteredProducts: _allProducts,
        currentQuery: event.query,
      ));
      return;
    }

    final query = event.query.toLowerCase();
    final filteredProducts = _allProducts
        .where((product) => 
          product.name.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query))
        .toList();

    print('✅ Found ${filteredProducts.length} matching products');
    emit(ProductSearchLoaded(
      products: _allProducts,
      filteredProducts: filteredProducts,
      currentQuery: event.query,
    ));
  }
}