import 'package:flutter/material.dart';
import 'package:mobile/ui/screens/navigation_screen.dart';
import '../widgets/app_header.dart';
import '../widgets/action_button.dart';
import '../widgets/start_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> shoppingLists = ['09/07', '15/07', '24/07'];
  int currentIndex = 0;

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
              AppHeader(
                shoppingLists: shoppingLists,
                currentIndex: currentIndex,
                onIndexChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                onAddList: () {
                  setState(() {
                    shoppingLists.add('New List');
                    currentIndex = shoppingLists.length - 1;
                  });
                },
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: ActionButton(
                      icon: Icons.edit,
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () {
                        if (shoppingLists.isNotEmpty) {
                          _navigateToEditList(context);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ActionButton(
                      icon: Icons.search,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (shoppingLists.isNotEmpty) {
                          _searchProduct(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80),
              Center(
                child: StartButton(
                  onPressed: () {
                    if (shoppingLists.isNotEmpty) {
                      _startShopping(context);
                    }
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
    // Implement navigation to edit list screen
  }

  void _searchProduct(BuildContext context) {
    // Implement navigation to search screen
  }

  void _startShopping(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NavigationPage()),
    );
  }
}