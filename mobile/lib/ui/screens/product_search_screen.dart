import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/product_search_bloc.dart';

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
    
    // Load initial products
    context.read<ProductSearchBloc>().add(LoadProducts());
    context.read<ProductSearchBloc>().add(LoadProducts());

    // Setup search listener
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

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
        actions: [
          // Debug button
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () {
              print('\n=== DEBUG INFO ===');
              final state = context.read<ProductSearchBloc>().state;
              print('Current state: ${state.runtimeType}');
              if (state is ProductSearchLoaded) {
                print('Total products: ${state.products.length}');
                print('Filtered: ${state.filteredProducts.length}');
                print('Query: ${state.currentQuery}');
              }
              print('==================\n');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search field
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

          // Results list
          Expanded(
            child: BlocBuilder<ProductSearchBloc, ProductSearchState>(
              builder: (context, state) {
                if (state is ProductSearchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
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
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
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
                            trailing: const Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: 32,
                            ),
                            onTap: () {
                              // TODO: Handle product selection
                              print('Selected: ${product.name}');
                            },
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
      ),
    );
  }
}