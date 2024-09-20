import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/action_button.dart';
import '../widgets/start_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Shop4Me',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const AppHeader(),
              const SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                      child: ActionButton(
                          icon: Icons.edit,
                          color: Theme.of(context).colorScheme.secondary,
                          onPressed: () => _navigateToEditList(context))),
                  const SizedBox(width: 16),
                  Expanded(
                      child: ActionButton(
                          icon: Icons.search,
                          color: Theme.of(context).primaryColor,
                          onPressed: () => _searchProduct(context))),
                ],
              ),
              const SizedBox(height: 80),
              Center(
                child: StartButton(
                  onPressed: () {
                    // TODO: Implement start shopping functionality
                    _startShopping(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToEditList(BuildContext context) {
    // TODO: Implement navigation to edit list screen
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const EditListScreen()),
    // );
    print('Navigating to edit list screen');
  }

  void _searchProduct(BuildContext context) {
    // TODO: Implement navigation to search screen
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const NavigationScreen()),
    // );
    print('Navigating to search screen');
  }

  void _startShopping(BuildContext context) {
    // TODO: Implement start shopping functionality
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const Shopping()),
    // );
    print('Starting shopping');
  }
}
