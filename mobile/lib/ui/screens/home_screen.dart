import 'package:flutter/material.dart';
import 'package:mobile/ui/screens/navigation_screen.dart';
import '../../utils/screen_utils.dart';
import 'package:mobile/ui/screens/shopping_list_screen.dart';
import 'package:mobile/blocs/shopping_list_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: constraints.maxHeight * 0.02,
                horizontal: constraints.maxWidth * 0.04,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Shop4Me',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Flexible(
                    flex: 3,
                    child: AppHeader(
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
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  Flexible(
                    flex: 2,
                    child: Row(
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
                        SizedBox(width: constraints.maxWidth * 0.04),
                        Expanded(
                          child: ActionButton(
                            icon: Icons.search,
                            color: Theme.of(context).colorScheme.primary,
                            onPressed: () {
                              if (shoppingLists.isNotEmpty) {
                                _searchProduct(context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: StartButton(
                      onPressed: () {
                        if (shoppingLists.isNotEmpty) {
                          _startShopping(context);
                        }
                      },
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
