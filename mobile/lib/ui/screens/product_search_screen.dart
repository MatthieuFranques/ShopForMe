// lib/ui/screens/product_search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/models/product.dart';
import '../../blocs/product_search_bloc.dart';
import '../../blocs/shopping_list_bloc.dart';

class ProductSearchScreen extends StatefulWidget {
  final int shopId;

  const ProductSearchScreen({
    super.key,
    required this.shopId,
  });

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    print('🚀 Initializing product search screen');

    // Dispatch de l'événement LoadProducts
    context.read<ProductSearchBloc>().add(LoadProducts());

    _searchController.addListener(() {
      context.read<ProductSearchBloc>().add(
            SearchProducts(_searchController.text),
          );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  bool _isProductInList(String productId, ShoppingListLoaded shoppingListState) {
    return shoppingListState.currentList.products
        .any((p) => p.id == productId);
  }

  void _handleProductSelection(
    BuildContext context,
    Product product,
    ShoppingListLoaded shoppingListState,
  ) {
    final bool isInList = _isProductInList(product.id, shoppingListState);

    if (isInList) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.name} est déjà dans votre liste'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    context.read<ShoppingListBloc>().add(
          AddProductToShoppingList(product),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} ajouté à votre liste'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'ANNULER',
          textColor: Colors.white,
          onPressed: () {
            context.read<ShoppingListBloc>().add(
                  RemoveProductFromList(product.id),
                );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rechercher un produit',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 1, 28, 64),
          ),
        ),
      ),
      body: BlocBuilder<ShoppingListBloc, ShoppingListState>(
        builder: (context, shoppingListState) {
          if (shoppingListState is! ShoppingListLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocus,
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Nom du produit...',
                    hintStyle: const TextStyle(
                      color: Colors.white70,
                      fontSize: 28,
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.secondary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 32,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<ProductSearchBloc, ProductSearchState>(
                  builder: (context, state) {
                    if (state is ProductSearchLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is ProductSearchError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is ProductSearchLoaded) {
                      final products = state.filteredProducts;

                      if (products.isEmpty) {
                        return const Center(
                          child: Text(
                            'Aucun produit trouvé',
                            style: TextStyle(fontSize: 24),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final bool isInList = _isProductInList(
                            product.id,
                            shoppingListState,
                          );

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isInList
                                    ? theme.colorScheme.secondary
                                    : theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                title: Text(
                                  product.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  product.category,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                trailing: Icon(
                                  isInList
                                      ? Icons.check_circle
                                      : Icons.add_circle_outline,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                onTap: () => _handleProductSelection(
                                  context,
                                  product,
                                  shoppingListState,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return const Center(
                      child: Text('Commencez votre recherche'),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
