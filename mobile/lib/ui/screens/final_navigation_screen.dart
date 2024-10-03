import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/navigation_bloc.dart';
import 'package:mobile/ui/screens/home_screen.dart';

class FinalNavigationScreen extends StatefulWidget {
  @override
  _FinalNavigationScreenState createState() => _FinalNavigationScreenState();
}

class _FinalNavigationScreenState extends State<FinalNavigationScreen> {
  @override
  void initState() {
    super.initState();
    // Retour à la page d'accueil après 5 secondes
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
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
        backgroundColor: Color.fromARGB(255, 242, 238, 216),
      ),
      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône de validation
              Expanded(
                child: Center(
                  child: Icon(
                    Icons.check_circle,
                    size: screenWidth * 0.8,
                    color: Color.fromARGB(255, 1, 28, 64),
                  ),
                ),
              ),
              // Message de fin
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "La liste est terminée !",
                  style: TextStyle(
                    fontSize: screenHeight * 0.05,
                    color: Color.fromARGB(255, 1, 28, 64),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
