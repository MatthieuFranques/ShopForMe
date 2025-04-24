import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/navigation/navigation_export.dart';
import 'package:mobile/ui/screens/home_screen.dart';

class FinalNavigationScreen extends StatefulWidget {
  const FinalNavigationScreen({super.key});

  @override
  FinalNavigationScreenState createState() => FinalNavigationScreenState();
}

class FinalNavigationScreenState extends State<FinalNavigationScreen> {
  @override
  void initState() {
    super.initState();
    // Return menu
    final navigator = Navigator.of(context);
    Future.delayed(const Duration(seconds: 9), () {
      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
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
        backgroundColor: const Color.fromARGB(255, 242, 238, 216),
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
                    color: const Color.fromARGB(255, 1, 28, 64),
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
                    color: const Color.fromARGB(255, 1, 28, 64),
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
