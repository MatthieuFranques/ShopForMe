import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/screen_utils.dart';
import '../widgets/action_button.dart';
import '../widgets/app_header.dart';
import '../widgets/start_button.dart';
import 'package:mobile/blocs/product_search_bloc.dart';
import 'package:mobile/blocs/shopping_list_bloc.dart';
import 'package:mobile/models/shopping_lists_collection.dart';
import 'package:mobile/services/store_service.dart';

import 'package:mobile/ui/screens/navigation_screen.dart';
import 'package:mobile/ui/screens/product_search_screen.dart';
import 'package:mobile/ui/screens/shopping_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ShoppingListsCollection? _collection;
  int currentIndex = 0;
  final int currentShopId = 2;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadShop();
    await _loadShoppingLists();
  }

  Future<void> _loadShop() async {
    try {
      print('🏪 Loading shop data...');
      final storeService = context.read<StoreService>();
      await storeService.loadCurrentShop(currentShopId);
      print('✅ Successfully loaded shop data');
    } catch (e) {
      print('❌ Failed to load shop data: $e');
    }
  }

  Future<void> _loadShoppingLists() async {
    try {
      print('📝 Loading shopping lists...');
      final jsonString = await rootBundle.loadString('assets/list/defaultShoppingList.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      setState(() {
        _collection = ShoppingListsCollection.fromJson(jsonData);
        print('✅ Loaded ${_collection?.lists.length ?? 0} shopping lists');
      });
    } catch (e) {
      print('❌ Error loading shopping lists: $e');
      // Fallback to create an empty collection
      setState(() {
        _collection = ShoppingListsCollection(lists: [], currentIndex: 0);
      });
    }
  }

  void _navigateToEditList(BuildContext context) {
    if (_collection == null || _collection!.lists.isEmpty) {
      print('⚠️ Cannot edit: No shopping lists available');
      return;
    }
    
    print('📝 Navigating to edit current shopping list');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ShoppingListBloc(
            currentShop: context.read<StoreService>().currentShop,
          ),
          child: const ShoppingListScreen(),
        ),
      ),
    );
  }

  void _searchProduct(BuildContext context) {
    if (_collection == null || _collection!.lists.isEmpty) {
      print('⚠️ Cannot search: No shopping lists available');
      return;
    }

    print('🔍 Opening product search');
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
    if (_collection == null || _collection!.lists.isEmpty) {
      print('⚠️ Cannot start: No shopping lists available');
      return;
    }

    print('🛒 Starting shopping navigation');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NavigationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);

    final titleSize = context.getResponsiveFontSize(32);
    final verticalPadding = context.getResponsiveSize(16);
    final horizontalPadding = context.getResponsiveSize(24);
    final spacingHeight = context.getResponsiveSize(20);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                SizedBox(
                  height: context.getResponsiveSize(120),
                  child: AppHeader(
                    shoppingLists: _collection?.lists ?? [],
                    currentIndex: currentIndex,
                    onIndexChanged: (index) {
                      print('📑 Switching to shopping list $index');
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    onAddList: () {
                      print('➕ Creating new shopping list');
                      // À implémenter : logique pour ajouter une nouvelle liste
                    },
                  ),
                ),
                SizedBox(height: spacingHeight * 1.5),
                Row(
                  children: [
                    Expanded(
                      child: ActionButton(
                        icon: Icons.edit,
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: () => _navigateToEditList(context),
                      ),
                    ),
                    SizedBox(width: context.getResponsiveSize(16)),
                    Expanded(
                      child: ActionButton(
                        icon: Icons.search,
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () => _searchProduct(context),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacingHeight),
                Center(
                  child: StartButton(
                    onPressed: () => _startShopping(context),
                  ),
                ),
                SizedBox(height: spacingHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }
}