// lib/ui/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/shopping_list_bloc.dart';
import 'package:mobile/blocs/product_search_bloc.dart';
import 'package:mobile/ui/screens/shopping_list_screen.dart';
import 'package:mobile/ui/widgets/app_header.dart';
import 'package:mobile/ui/widgets/action_button.dart';
import 'package:mobile/ui/widgets/start_button.dart';
import 'package:mobile/ui/screens/product_search_screen.dart';
import 'package:mobile/ui/screens/navigation_screen.dart';
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
    // Aucun chargement manuel ici, le ShoppingListBloc gère cela
  }

  void _navigateToEditList(BuildContext context, ShoppingListLoaded state) {
    if (state.shoppingLists.isEmpty) {
      print('⚠️ Cannot edit: No shopping lists available');
      return;
    }

    print('📝 Navigating to edit current shopping list');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ShoppingListScreen(),
      ),
    );
  }

  void _searchProduct(BuildContext context, ShoppingListLoaded state) {
    if (state.shoppingLists.isEmpty) {
      print('⚠️ Cannot search: No shopping lists available');
      return;
    }

    print('🔍 Opening product search');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProductSearchScreen(shopId: 1),
      ),
    );
  }

  void _startShopping(BuildContext context, ShoppingListLoaded state) {
    if (state.shoppingLists.isEmpty) {
      print('⚠️ Cannot start: No shopping lists available');
      return;
    }

    print('🛒 Starting shopping navigation');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NavigationPage()),
    );
  }

  void _handleAddList(BuildContext context) {
    print('➕ Creating new shopping list');
    context.read<ShoppingListBloc>().add(CreateNewShoppingList());
  }

  void _handleIndexChanged(BuildContext context, int index, ShoppingListLoaded state) {
    print('📑 Switching to shopping list $index');
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
                // TODO: Implémenter la suppression de la liste
                // context.read<ShoppingListBloc>().add(DeleteShoppingList(state.currentList.id));
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
                      SizedBox(height: spacingHeight),
                      Center(
                        child: StartButton(
                          onPressed: () => _startShopping(context, state),
                        ),
                      ),
                      SizedBox(height: spacingHeight),
                    ],
                  ),
                ),
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
}
