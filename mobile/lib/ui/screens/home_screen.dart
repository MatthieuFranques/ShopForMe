import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/shopping_list/shopping_list_export.dart';

import 'package:mobile/ui/screens/navigation_screen.dart';
import 'package:mobile/ui/screens/product_search_screen.dart';
import 'package:mobile/ui/screens/shopping_list_screen.dart';

import 'package:mobile/ui/widgets/action_button.dart';
import 'package:mobile/ui/widgets/app_header.dart';
import 'package:mobile/ui/widgets/start_button.dart';

import 'package:mobile/utils/screen_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  final int currentShopId = 2;

  @override
  void initState() {
    super.initState();
  }

/// Functions to handle user actions
  void _navigateToEditList(BuildContext context, ShoppingListLoaded state) {
    if (state.shoppingLists.isEmpty) {
      _showErrorSnackBar(context, 'Aucune liste de courses disponible');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ShoppingListScreen(),
      ),
    );
  }

  void _searchProduct(BuildContext context, ShoppingListLoaded state) {
    if (state.shoppingLists.isEmpty) {
      _showErrorSnackBar(context, 'Aucune liste de courses disponible');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProductSearchScreen(shopId: 2),
      ),
    );
  }

  void _startShopping(BuildContext context, ShoppingListLoaded state) {
    if (state.shoppingLists.isEmpty) {
      _showErrorSnackBar(context, 'Aucune liste de courses disponible');
      return;
    }

    if (state.currentList.products.isEmpty) {
      _showErrorSnackBar(context, 'La liste de courses est vide');
      return;
    }

    print('Starting shopping with list: ${state.currentList.products}');
    Navigator.push(
      context,
      MaterialPageRoute(
      builder: (context) => NavigationPage(
        shoppingList: state.currentList.products,
      ),
      ),
    );
    }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleAddList(BuildContext context) {
    context.read<ShoppingListBloc>().add(CreateNewShoppingList());
  }

  void _handleIndexChanged(BuildContext context, int index, ShoppingListLoaded state) {
    setState(() {
      currentIndex = index;
    });
    if (state.shoppingLists.length > index) {
      context.read<ShoppingListBloc>().add(
            SelectShoppingList(state.shoppingLists[index].id),
          );
    }
  }

  void _handleDeleteList(BuildContext context, ShoppingListLoaded state) {
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
                Navigator.pop(context);
                context.read<ShoppingListBloc>().add(
                      DeleteShoppingList(state.currentList.id),
                    );
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

/// Build method
  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);

    final titleSize = context.getResponsiveFontSize(32);
    final verticalPadding = context.getResponsiveSize(16);
    final horizontalPadding = context.getResponsiveSize(24);
    final spacingHeight = context.getResponsiveSize(20);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ShoppingListBloc, ShoppingListState>(
          builder: (context, state) {
            if (state is ShoppingListLoading) {
              return const Center(child: CircularProgressIndicator());
            }
/// Main content
            if (state is ShoppingListLoaded) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: verticalPadding,
                    horizontal: horizontalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Shop4Me',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontSize: titleSize,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: spacingHeight),
                      SizedBox(
                        height: context.getResponsiveSize(120),
                        child: AppHeader(
                          shoppingLists: state.shoppingLists,
                          currentIndex: currentIndex,
                          onIndexChanged: (index) => _handleIndexChanged(context, index, state),
                          onAddList: () => _handleAddList(context),
                        ),
                      ),
                      SizedBox(height: spacingHeight * 1.5),
                      Row(
                        children: [
                          Expanded(
                            child: ActionButton(
                              icon: Icons.edit,
                              color: Theme.of(context).colorScheme.secondary,
                              onPressed: () => _navigateToEditList(context, state),
                            ),
                          ),
                          SizedBox(width: context.getResponsiveSize(16)),
                          Expanded(
                            child: ActionButton(
                              icon: Icons.search,
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () => _searchProduct(context, state),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: spacingHeight * 2),
                      Center(
                        child: StartButton(
                          onPressed: () {
                            if (state.shoppingLists.isNotEmpty) {
                              _startShopping(context, state);
                            }
                          },
                        ),
                      ),
                      if (state.shoppingLists.isNotEmpty) ...[
                        SizedBox(height: spacingHeight),
                        Center(
                          child: TextButton.icon(
                            onPressed: () => _handleDeleteList(context, state),
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('Supprimer la liste'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }
/// Error state
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
                    TextButton(
                      onPressed: () {
                        context.read<ShoppingListBloc>().add(LoadShoppingList());
                      },
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              );
            }
/// Default state
            return const Center(child: Text('État inconnu'));
          },
        ),
      ),
    );
  }
}