import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/product_search_bloc.dart';
import 'package:mobile/services/store_service.dart';
import 'package:mobile/ui/screens/navigation_screen.dart';
import 'package:mobile/ui/screens/product_search_screen.dart';
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
  final int currentShopId = 2;

  void _navigateToEditList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ShoppingListBloc(),
          child: const ShoppingListPage(),
        ),
      ),
    );
  }

  void _searchProduct(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ProductSearchBloc(
            context.read<StoreService>(),
          ),
          child: ProductSearchScreen(shopId: currentShopId),
        ),
      ),
    );
  }

  void _startShopping(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NavigationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);

    // Utiliser getResponsiveSize pour les dimensions
    final titleSize = context.getResponsiveFontSize(32);
    final verticalPadding = context.getResponsiveSize(16);
    final horizontalPadding = context.getResponsiveSize(24);
    final spacingHeight = context.getResponsiveSize(20);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Shop4Me',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: titleSize,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacingHeight),
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
              SizedBox(height: spacingHeight * 1.5),
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
                    SizedBox(width: context.getResponsiveSize(16)),
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
              SizedBox(height: spacingHeight),
            ],
          ),
        ),
      ),
    );
  }
}