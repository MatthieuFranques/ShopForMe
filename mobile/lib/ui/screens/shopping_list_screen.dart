import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/shopping_list_bloc.dart';
import 'package:mobile/ui/screens/product_search_screen.dart';

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ShoppingListBloc>().add(LoadShoppingList());
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ShoppingList',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 1, 28, 64),
          ),
        ),
      ),
      body: Column(
        children: [
          BlocBuilder<ShoppingListBloc, ShoppingListState>(
            builder: (context, state) {
              if (state is ShoppingListLoading) {
                return Container(
                  height: screenHeight * 0.1,
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.primary,
                  child: const Center(child: CircularProgressIndicator()),
                );
              } else if (state is ShoppingListLoaded) {
                final invalidCount = state.invalidProducts.length;
                return Container(
                  height: screenHeight * 0.1,
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.secondary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.list, size: screenHeight * 0.06, color: Colors.white),
                          const SizedBox(width: 16),
                          Text(
                            state.shoppingList.date,
                            style: TextStyle(
                              fontSize: screenHeight * 0.04,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      if (invalidCount > 0)
                        Container(
                          margin: const EdgeInsets.only(right: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$invalidCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              } else {
                return Container(
                  height: screenHeight * 0.1,
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.primary,
                  child: const Center(child: Text('Unknown state.', style: TextStyle(color: Colors.white))),
                );
              }
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<ShoppingListBloc, ShoppingListState>(
              builder: (context, state) {
                if (state is ShoppingListLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ShoppingListLoaded) {
                  final products = state.shoppingList.products;
                  if (products.isEmpty) {
                    return const Center(
                      child: Text(
                        'Aucun produit dans la liste',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: products.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final isInvalid = state.invalidProducts.any((p) => p.id == product.id);

                      return Container(
                        height: screenHeight * 0.1,
                        width: double.infinity,
                        color: isInvalid 
                            ? Colors.red.shade300
                            : Theme.of(context).colorScheme.tertiary,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      product.name,
                                      style: TextStyle(
                                        fontSize: screenHeight * 0.04,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Rayon: ${product.rayon}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, size: screenHeight * 0.06, color: Colors.white),
                              onPressed: () {
                                context.read<ShoppingListBloc>().add(
                                  RemoveProductFromList(product.id),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is ShoppingListError) {
                  return Center(
                    child: Text(state.message),
                  );
                } else {
                  return const Center(child: Text('Unknown state.'));
                }
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductSearchScreen(shopId: 1),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: screenHeight * 0.1,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.add_rounded,
                      size: screenHeight * 0.08,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: screenHeight * 0.1,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_back,
                      size: screenHeight * 0.08,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}