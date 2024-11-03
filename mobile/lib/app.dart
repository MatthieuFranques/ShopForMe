// 3. app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/navigation_bloc.dart';
import 'package:mobile/blocs/product_search_bloc.dart';
import 'ui/screens/home_screen.dart';
import 'config/theme.dart';
import 'utils/screen_utils.dart';
import 'services/store_service.dart';
import 'services/cache_service.dart';

class Shop4MeApp extends StatelessWidget {
  final StoreService storeService;
  final CacheService cacheService;

  const Shop4MeApp({
    super.key, 
    required this.storeService,
    required this.cacheService,
  });
@override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: storeService),
        RepositoryProvider.value(value: cacheService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NavigationBloc(storeService)
              ..add(LoadNavigationEvent()),
          ),
          BlocProvider(
            create: (context) => ProductSearchBloc(storeService),
          ),
        ],
        child: Builder(
          builder: (context) {
            ScreenUtils.init(context);
            return MaterialApp(
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