import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/navigation_bloc.dart';

class NavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hide back button
        title: Image.asset(
          'assets/logo.png', // Your logo path
          height: 50,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          if (state is NavigationLoadedState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Object name in a large rectangle
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        state.objectName, // The name of the object
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Big arrow in the middle
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Icon(
                    state.arrowDirection == ArrowDirection.left
                        ? Icons.arrow_left
                        : Icons.arrow_right, // Arrow based on state
                    size: 100,
                    color: Colors.blue,
                  ),
                ),

                // Movement instruction
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    state.instruction, // Example: "Faites 3 pas vers la gauche"
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Bottom navigation bar with two large buttons
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Retour', style: TextStyle(fontSize: 18)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle button press
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Suivant', style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // Loading or error state
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
