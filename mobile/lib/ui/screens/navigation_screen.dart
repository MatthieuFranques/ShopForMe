import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/navigation/navigation_export.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/services/navigation/direction_service.dart';
import 'package:mobile/ui/screens/final_navigation_screen.dart';

class NavigationPage extends StatelessWidget {
  final List<Product> shoppingList;

  const NavigationPage({
    super.key,
    required this.shoppingList,
  });

  @override
  Widget build(BuildContext context) {
    // 🔥 Récupération de StoreService depuis le RepositoryProvider

    return BlocProvider(
      create: (context) => NavigationBloc()
        ..add(LoadNavigationEvent(products: shoppingList)),
      child: NavigationView(shoppingList: shoppingList),
    );
  }
}

class NavigationView extends StatefulWidget {
  final List<Product> shoppingList;

  const NavigationView({
    super.key,
    required this.shoppingList,
  });

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  void _handleProductFound(BuildContext context, NavigationLoadedState state) {
    if (state.isLastProduct) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FinalNavigationScreen()),
      );
    } else {
      context.read<NavigationBloc>().add(ProductFoundEvent(
            product: widget.shoppingList[0], // Le produit actuel
          ));
    }
  }

  void _handleSkipProduct(BuildContext context) {
    context.read<NavigationBloc>().add(ProductFoundEvent(
          product: widget.shoppingList[0], // Le produit actuel
        ));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shop4Me',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 1, 28, 64),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 242, 238, 216),
      ),
      body: BlocConsumer<NavigationBloc, NavigationState>(
        listener: (context, state) {
          if (state is NavigationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is NavigationLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is NavigationLoadedState) {
            return SafeArea(
              child: Column(
                children: [
                  // Bloc avec l'aliment recherché
                  Padding(
                    padding: const EdgeInsets.all(8.0), // Reduced padding
                    child: Container(
                      height: screenHeight * 0.08, // Reduced height
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          state.objectName,
                          style: TextStyle(
                            fontSize: screenHeight * 0.035, // Reduced font size
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  // Icône de navigation
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4), // Minimal padding
                    child: Icon(
                      _getDirectionIcon(state.arrowDirection),
                      size: screenWidth * 0.3, // Further reduced size
                      color: const Color.fromARGB(255, 1, 28, 64),
                    ),
                  ),
                  // Instruction de navigation
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4), // Minimal padding
                    child: Text(
                      state.instruction,
                      style: TextStyle(
                        fontSize: screenHeight * 0.03, // Further reduced font size
                        color: const Color.fromARGB(255, 1, 28, 64),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(child: SizedBox()), // Flexible space
                  // Boutons de contrôle
                  if (!state.isLastProduct)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4), // Minimal padding
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () =>
                                  _handleProductFound(context, state),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                              child: Container(
                                width: double.infinity,
                                height: screenHeight * 0.06, // Further reduced height
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.check,
                                  size: screenHeight * 0.04, // Further reduced size
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _handleSkipProduct(context),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                              ),
                              child: Container(
                                width: double.infinity,
                                height: screenHeight * 0.06, // Further reduced height
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.skip_next,
                                  size: screenHeight * 0.04, // Further reduced size
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          }

          return const Center(
              child: CircularProgressIndicator()); // Garde l'utilisateur dans un état de chargement.
        },
      ),
    );
  }

  IconData _getDirectionIcon(ArrowDirection direction) {
    switch (direction) {
      case ArrowDirection.nord:
        return Icons.arrow_upward;
      case ArrowDirection.sud:
        return Icons.arrow_downward;
      case ArrowDirection.est:
        return Icons.arrow_forward;
      case ArrowDirection.ouest:
        return Icons.arrow_back;
    }
  }
}