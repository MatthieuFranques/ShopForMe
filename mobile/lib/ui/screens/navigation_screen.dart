import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;
import 'package:mobile/blocs/navigation/navigation_export.dart';
import 'package:mobile/models/product.dart';
import 'package:mobile/services/navigation/compass_service.dart';
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
      create: (context) =>
          NavigationBloc()..add(LoadNavigationEvent(products: shoppingList)),
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

class _NavigationViewState extends State<NavigationView>
    with SingleTickerProviderStateMixin {
  // Contrôleur d'animation pour l'icône de direction
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // Initialisation du contrôleur d'animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
            _animationController.value = 0.0;
            _animationController.forward();

            final bool useSafeArea =
                true; // ← change cette valeur selon ton besoin

            final content = Column(
              children: [
                // === Ton contenu original ici ===
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: screenHeight * 0.08,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        state.objectName,
                        style: TextStyle(
                          fontSize: screenHeight * 0.035,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

                // Section information sur l'orientation
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Direction: ${state.compassDirection.toStringAsFixed(0)}°",
                        style: TextStyle(
                          fontSize: screenHeight * 0.02,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "Angle: ${state.adjustedAngle.toStringAsFixed(0)}°",
                        style: TextStyle(
                          fontSize: screenHeight * 0.02,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // ... Le reste de la Column inchangé ...
                if (state.objectName != "Terminé !")
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: (state.adjustedAngle * (math.pi / 180) * -1),
                          child: Icon(
                            Icons.navigation,
                            size: screenWidth * 0.8,
                            color: const Color.fromARGB(255, 1, 28, 64),
                          ),
                        );
                      },
                    ),
                  ),
                if (state.objectName == "Terminé !")
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Expanded(
                      child: Center(
                        child: Icon(
                          Icons.check_circle,
                          size: screenWidth * 0.8,
                          color: const Color.fromARGB(255, 1, 28, 64),
                        ),
                      ),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    state.instruction,
                    style: TextStyle(
                      fontSize: screenHeight * 0.03,
                      color: const Color.fromARGB(255, 1, 28, 64),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                if (!state.isLastProduct)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
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
                              height: screenHeight * 0.06,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.check,
                                size: screenHeight * 0.04,
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
                              height: screenHeight * 0.06,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.skip_next,
                                size: screenHeight * 0.04,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );

            // 🔁 Maintenant on retourne conditionnellement le widget
            if (useSafeArea) {
              return BlocListener<NavigationBloc, NavigationState>(
                listener: (context, state) {
                  if (state is NavigationLoadedState && state.isLastProduct) {
                    Future.delayed(const Duration(seconds: 5), () {
                      Navigator.pop(context);
                    });
                  }
                },
                child: SafeArea(child: content),
              );
            }
          }

          // État par défaut
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
