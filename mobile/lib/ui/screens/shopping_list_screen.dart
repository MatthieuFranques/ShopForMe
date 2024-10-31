import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/shopping_list_bloc.dart';

class ShoppingListPage extends StatelessWidget {
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
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state is ShoppingListLoaded) {
                return Container(
                  height: screenHeight * 0.1, 
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.secondary,
                  child: Row(
                    children: [
                      Icon(Icons.list, size: screenHeight * 0.06, color: Colors.white), 
                      SizedBox(width: 16), 
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
                );
              } else {
                return Container(
                  height: screenHeight * 0.1, 
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.primary,
                  child: Center(child: Text('Unknown state.', style: TextStyle(color: Colors.white))),
                );
              }
            },
          ),
          SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<ShoppingListBloc, ShoppingListState>(
              builder: (context, state) {
                if (state is ShoppingListLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ShoppingListLoaded) {
                  final products = state.shoppingList.products;
                  return ListView.separated(
                    itemCount: products.length,
                    separatorBuilder: (context, index) => SizedBox(height: 10), 
                    itemBuilder: (context, index) {
                      final product = products[index];

                      return Container(
                        height: screenHeight * 0.1, 
                        width: double.infinity,
                        color: Theme.of(context).colorScheme.tertiary, 
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  product.name,
                                  style: TextStyle(
                                    fontSize: screenHeight * 0.04,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, size: screenHeight * 0.06, color: Colors.white),
                              onPressed: () {
                                // Supprimer produit de la liste
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is ShoppingListError) {
                  return Center(child: Text('Failed to load shopping list.'));
                } else {
                  return Center(child: Text('Unknown state.'));
                }
              },
            ),
          ),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => ResearchScreen()),
                    // );
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
                    // Action à réaliser lors du clic sur le bouton de skip
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
                      Icons.skip_next,
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
