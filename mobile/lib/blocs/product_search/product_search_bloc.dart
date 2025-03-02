import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/models/product.dart';
import './product_search_event.dart';
import './product_search_state.dart';

class ProductSearchBloc extends Bloc<ProductSearchEvent, ProductSearchState> {
  List<Product> _allProducts = [];

  ProductSearchBloc() : super(ProductSearchInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductSearchState> emit,
  ) async {
        if (_allProducts.isNotEmpty) {
      emit(ProductSearchLoaded(
        products: _allProducts,
        filteredProducts: _allProducts,
      ));
      return;
    }

    emit(ProductSearchLoading());
    try {
      print('🔄 Loading products');
      final List<Product> products = [Product(id: "1", name: "pomme", category: "", rayon: "" )];
      _allProducts = products;
      print('✅ Loaded ${products.length} products');
      
      emit(ProductSearchLoaded(
        products: products,
        filteredProducts: products,
      ));
    } catch (e) {
      print('❌ Error loading products: $e');
      emit(const ProductSearchError('Impossible de charger les produits. Veuillez réessayer.'));
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