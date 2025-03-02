import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/product_search/product_search_export.dart';
import 'package:mobile/blocs/shopping_list/shopping_list_export.dart';
import 'ui/screens/home_screen.dart';
import 'config/theme.dart';
import 'utils/screen_utils.dart';
import 'services/cache_service.dart';

class Shop4MeApp extends StatelessWidget {
  final CacheService cacheService;

  const Shop4MeApp({
    super.key,
    required this.cacheService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: cacheService),
      ],
      child: MultiBlocProvider(
        providers: [
          // BlocProvider(
          //   create: (context) => NavigationBloc(storeService)
          //     ..add(LoadNavigationEvent(
          //         products: [])), // Initialisation avec une liste vide
          // ),
          BlocProvider(
            create: (context) => ProductSearchBloc(),
          ),
          BlocProvider(
            create: (context) => ShoppingListBloc(
            )..add(LoadShoppingList()), // Dispatch de l'événement ici
          ),
        ],
        child: Builder(
          builder: (context) {
            ScreenUtils.init(context);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Shop4Me',
              theme: Shop4MeTheme.getLightTheme(context),
              home: const HomeScreen(),
            );
          },
        ),
      ),
    );
  }
}
