import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/shopping_list/shopping_list_export.dart';
import 'package:mobile/ui/screens/navigation_screen.dart';
import 'package:mobile/ui/screens/product_search_screen.dart';
import 'package:mobile/ui/screens/shopping_list_screen.dart';
import 'package:mobile/ui/widgets/action_button.dart';
import 'package:mobile/ui/widgets/app_header.dart';
import 'package:mobile/utils/screen_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  final int currentShopId = 2;
  final String shoppingListEmpty = 'Aucune liste de courses disponible';
  static const String deleteList = 'Supprimer la liste';

  @override
  void initState() {
    super.initState();
  }

  void _navigateToEditList(BuildContext context, ShoppingListLoaded state) {
    if (state.shoppingLists.isEmpty) {
      _showErrorSnackBar(context, shoppingListEmpty);
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
      _showErrorSnackBar(context, shoppingListEmpty);
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
      _showErrorSnackBar(context, shoppingListEmpty);
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

  void _handleIndexChanged(
      BuildContext context, int index, ShoppingListLoaded state) {
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
          title: Semantics(
            label: deleteList,
            child: const Text(deleteList),
          ),
          content: Semantics(
            label: 'Confirmation de suppression',
            child: Text(
                'Voulez-vous vraiment supprimer "${state.currentList.name}" ?'),
          ),
          actions: [
            Semantics(
              label: 'Annuler la suppression',
              button: true,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
            ),
            Semantics(
              label: 'Confirmer la suppression',
              button: true,
              child: TextButton(
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
                      Semantics(
                        label: 'Titre de l\'écran d\'accueil',
                        child: Text(
                          'Shop4Me',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontSize: titleSize,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: spacingHeight),
                      SizedBox(
                        height: context.getResponsiveSize(120),
                        child: AppHeader(
                          shoppingLists: state.shoppingLists,
                          currentIndex: currentIndex,
                          onIndexChanged: (index) =>
                              _handleIndexChanged(context, index, state),
                          onAddList: () => _handleAddList(context),
                        ),
                      ),
                      SizedBox(height: spacingHeight * 1.5),
                      Row(
                        children: [
                          Expanded(
                            child: Semantics(
                              label: 'Éditer la liste de courses',
                              button: true,
                              child: ActionButton(
                                icon: Icons.edit,
                                color: Theme.of(context).colorScheme.secondary,
                                onPressed: () =>
                                    _navigateToEditList(context, state),
                              ),
                            ),
                          ),
                          SizedBox(width: context.getResponsiveSize(16)),
                          Expanded(
                            child: Semantics(
                              label: 'Rechercher un produit',
                              button: true,
                              child: ActionButton(
                                icon: Icons.search,
                                color: Theme.of(context).colorScheme.primary,
                                onPressed: () => _searchProduct(context, state),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: spacingHeight * 2),
                      Semantics(
                          label: 'Démarrer la course',
                          button: true,
                          child: _buildRoundButton(
                            context,
                            state.shoppingLists.isNotEmpty,
                            () => _startShopping(context,
                                state), // Passe la fonction de démarrage
                          )),
                      if (state.shoppingLists.isNotEmpty) ...[
                        SizedBox(height: spacingHeight),
                        Center(
                          child: Semantics(
                            label: 'Supprimer la liste de courses',
                            button: true,
                            child: TextButton.icon(
                              onPressed: () =>
                                  _handleDeleteList(context, state),
                              icon: const Icon(Icons.delete_outline),
                              label: const Text(deleteList),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                    TextButton(
                      onPressed: () {
                        context
                            .read<ShoppingListBloc>()
                            .add(LoadShoppingList());
                      },
                      child: const Text('Réessayer'),
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

  Widget _buildRoundButton(BuildContext context, bool hasShoppingLists,
      VoidCallback onStartShopping) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Material(
        color: Theme.of(context).colorScheme.secondary,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: hasShoppingLists
              ? onStartShopping
              : null, // Désactive si pas de liste
          customBorder: const CircleBorder(),
          child: const Center(
            child: Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 120,
            ),
          ),
        ),
      ),
    );
  }
}
