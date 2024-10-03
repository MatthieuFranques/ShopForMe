import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/navigation_bloc.dart';
import 'package:mobile/ui/screens/final_navigation_screen.dart';

class NavigationPage extends StatelessWidget {
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
        backgroundColor: Color.fromARGB(255, 242, 238, 216),
      ),
      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          if (state is NavigationLoadedState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bloc avec l'aliment recherché
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: screenHeight * 0.15,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        state.objectName,
                        style: TextStyle(
                          fontSize: screenHeight * 0.05,
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
                  padding: const EdgeInsets.symmetric(vertical: 16), 
                  child: Icon(
                    state.arrowDirection == ArrowDirection.left
                        ? Icons.arrow_back
                        : Icons.arrow_forward,
                    size: screenWidth * 0.65, 
                    color: Color.fromARGB(255, 1, 28, 64),
                  ),
                ),
                // Instruction de navigation
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    state.instruction,
                    style: TextStyle(
                      fontSize: screenHeight * 0.05,
                      color: Color.fromARGB(255, 1, 28, 64),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(), 
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        // Bouton de validation
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FinalNavigationScreen()),
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
                              Icons.check,
                              size: screenHeight * 0.08, 
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        // Bouton de skip pour passer à un autre aliment
                        child: ElevatedButton(
                          onPressed: () {
                            // to do
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
                ),
              ],
            );
          } else {
            // Loader si les données ne sont pas encore chargées
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
