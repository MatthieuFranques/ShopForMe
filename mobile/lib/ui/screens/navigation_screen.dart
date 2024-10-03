import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/navigation_bloc.dart';
import 'package:mobile/ui/screens/home_screen.dart';

class NavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Logo de l'application
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Shop4Me',
          style: TextStyle(
            fontSize: 48,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Bloc avec l'aliment recherché
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        state.objectName,
                        style: const TextStyle(
                          fontSize: 48,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                //Icon de navigation
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Icon(
                    state.arrowDirection == ArrowDirection.left
                        ? Icons.arrow_back
                        : Icons.arrow_forward,
                    size: 250,
                    color: Color.fromARGB(255, 1, 28, 64),
                  ),
                ),
                //Instruction de navigation
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    state.instruction,
                    style: const TextStyle(
                      fontSize: 48,
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
                        //Bouton de validation
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomeScreen()),
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
                            height: 80, 
                            alignment: Alignment.center, 
                            child: const Icon(
                              Icons.check,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        //Bouton de skip pour passer à un autre aliment
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
                            height: 80, 
                            alignment: Alignment.center, 
                            child: const Icon(
                              Icons.skip_next,
                              size: 60, 
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
            //Loader si les données à chercher n'ont pas été reçu
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
