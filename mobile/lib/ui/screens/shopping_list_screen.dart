import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/shopping_list_bloc.dart';
import 'package:mobile/ui/widgets/app_header.dart';
import 'package:mobile/ui/widgets/shopping_list_items.dart';
import 'package:mobile/ui/screens/product_search_screen.dart';
import 'package:mobile/utils/screen_utils.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Charger initialement la liste
    context.read<ShoppingListBloc>().add(LoadShoppingList());
  }

  void _handleDeleteProduct(int productId) {
    context
        .read<ShoppingListBloc>()
        .add(RemoveProductFromList(productId.toString()));
  }

  void _handleIndexChanged(int index) {
    print('📑 Switching to shopping list $index');
    setState(() {
      _currentIndex = index;
    });
    final state = context.read<ShoppingListBloc>().state;
    if (state is ShoppingListLoaded) {
      context
          .read<ShoppingListBloc>()
          .add(SelectShoppingList(state.shoppingLists[index].id));
    }
  }

  void _handleAddList() {
    print('➕ Creating new shopping list');
    context.read<ShoppingListBloc>().add(CreateNewShoppingList());
  }

  void _handleDeleteList() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer la liste'),
          content: const Text(
              'Voulez-vous vraiment supprimer cette liste de courses ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                final state = context.read<ShoppingListBloc>().state;
                if (state is ShoppingListLoaded) {
                  // TODO: Ajouter l'action de suppression
                  // context.read<ShoppingListBloc>().add(DeleteShoppingList(state.currentList.id));
                }
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    final spacingHeight = context.getResponsiveSize(20);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ShoppingListBloc, ShoppingListState>(
          builder: (context, state) {
            if (state is ShoppingListLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ShoppingListLoaded) {
              return Column(
                children: [
                  Container(
                    height: 80, // Hauteur fixe pour l'AppHeader
                    padding: EdgeInsets.symmetric(
                        horizontal: context.getResponsiveSize(16)),
                    child: AppHeader(
                      shoppingLists: state.shoppingLists,
                      currentIndex: _currentIndex,
                      onIndexChanged: _handleIndexChanged,
                      onAddList: _handleAddList,
                    ),
                  ),
                  Expanded(
                    child: state.currentList.products.isEmpty
                        ? _buildEmptyState()
                        : ShoppingListItems(
                            state: state,
                            onDeleteProduct: _handleDeleteProduct,
                          ),
                  ),
                  // Bottom Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: context.getResponsiveSize(160),
                        height: context.getResponsiveSize(100),
                        margin: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ProductSearchScreen(shopId: 2)),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Icon(
                            Icons.add,
                            size: context.getResponsiveSize(32),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        width: context.getResponsiveSize(160),
                        height: context.getResponsiveSize(100),
                        margin: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: _handleDeleteList,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Icon(
                            Icons.delete,
                            size: context.getResponsiveSize(32),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              );
            }

            if (state is ShoppingListError) {
              return Center(child: Text(state.message));
            }

            return const Center(child: Text('État inconnu'));
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_basket_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Aucun produit dans la liste',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
