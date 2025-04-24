import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/shopping_list/shopping_list_export.dart';
import 'package:mobile/blocs/product_search/product_search_export.dart';
import 'package:mobile/ui/widgets/app_header.dart';
import 'package:mobile/ui/widgets/shopping_list_items.dart';
import 'package:mobile/ui/screens/product_search_screen.dart';
import 'package:mobile/utils/screen_utils.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ShoppingListScreenState createState() => ShoppingListScreenState();
}

class ShoppingListScreenState extends State<ShoppingListScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    print('📝 Loading shopping list');
    context.read<ShoppingListBloc>().add(LoadShoppingList());
  }

  void _handleDeleteProduct(int productId) {
    context.read<ShoppingListBloc>().add(RemoveProductFromList(productId.toString()));
  }

  void _handleIndexChanged(int index) {
    print('📑 Switching to shopping list $index');
    setState(() {
      _currentIndex = index;
    });
    final state = context.read<ShoppingListBloc>().state;
    if (state is ShoppingListLoaded && state.shoppingLists.length > index) {
      context.read<ShoppingListBloc>().add(
        SelectShoppingList(state.shoppingLists[index].id)
      );
    }
  }

  void _handleAddList() {
    print('➕ Creating new shopping list');
    context.read<ShoppingListBloc>().add(CreateNewShoppingList());
  }

  void _handleDeleteList() {
    final state = context.read<ShoppingListBloc>().state;
    if (state is! ShoppingListLoaded) return;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer la liste'),
          content: Text('Voulez-vous vraiment supprimer "${state.currentList.name}" ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
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

  void _navigateToProductSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: context.read<ShoppingListBloc>(),
            ),
            BlocProvider.value(
              value: context.read<ProductSearchBloc>()..add(LoadProducts()),
            ),
          ],
          child: const ProductSearchScreen(shopId: 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);

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
                    height: 80,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.getResponsiveSize(16),
                    ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: Icons.add,
                        onPressed: _navigateToProductSearch,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      _buildActionButton(
                        icon: Icons.delete,
                        onPressed: _handleDeleteList,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ],
                  ),
                ],
              );
            }

            if (state is ShoppingListError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: context.getResponsiveSize(48),
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: context.getResponsiveFontSize(16),
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('État inconnu'));
          },
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      width: context.getResponsiveSize(80),
      height: context.getResponsiveSize(80),
      margin: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Icon(
          icon,
          size: context.getResponsiveSize(32),
          color: Colors.white,
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
            size: context.getResponsiveSize(64),
            color: Theme.of(context).colorScheme.primary.withAlpha((0.5 * 255).toInt()),
          ),
          SizedBox(height: context.getResponsiveSize(16)),
          Text(
            'Aucun produit dans la liste',
            style: TextStyle(
              fontSize: context.getResponsiveFontSize(18),
            ),
          ),
        ],
      ),
    );
  }
}