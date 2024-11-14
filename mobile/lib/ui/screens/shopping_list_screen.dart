import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/shopping_list_bloc.dart';
import 'package:mobile/ui/widgets/app_header.dart';
import 'package:mobile/ui/widgets/action_button.dart';
import 'package:mobile/ui/screens/product_search_screen.dart';
import 'package:mobile/utils/screen_utils.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ShoppingListBloc>().add(LoadShoppingList());
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
    // Afficher une modal de confirmation
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer la liste'),
          content: const Text('Voulez-vous vraiment supprimer cette liste de courses ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Ajouter l'action de suppression
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

  void _handleDeleteProduct(String productId) {
    context.read<ShoppingListBloc>().add(RemoveProductFromList(productId));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    
    final fontListItem = context.getResponsiveFontSize(18);
    final horizontalPadding = context.getResponsiveSize(24);
    final spacingHeight = context.getResponsiveSize(20);
    final spacingTop = context.getResponsiveSize(20);
    return Scaffold(
       body: BlocBuilder<ShoppingListBloc, ShoppingListState>(
        builder: (context, state) {
          if (state is ShoppingListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ShoppingListLoaded) {
            return Column(
              children: [
                SizedBox(
                  height: spacingTop,
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
                    : _buildProductsList(state, context),
                ),
              ],
            );
          }

          if (state is ShoppingListError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text('État inconnu'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductSearchScreen(shopId: 1),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

//if there is no product in the list
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


  Widget _buildProductsList(ShoppingListLoaded state, BuildContext context) {

    final fontSizeRayon = context.getResponsiveFontSize(8);
    final verticalPaddingListItems = context.getResponsiveSize(16);
    return ListView.separated(
      padding: EdgeInsets.all(verticalPaddingListItems),
      itemCount: state.currentList.products.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final product = state.currentList.products[index];
        final isInvalid = state.invalidProducts.contains(product);

        return Container(
          decoration: BoxDecoration(
            color: isInvalid ? Colors.red.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              product.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
                product.rayon,
                style: TextStyle(fontSize: fontSizeRayon),
            overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => _handleDeleteProduct(product.id),
            ),
          ),
        );
      },
    );
  }
}