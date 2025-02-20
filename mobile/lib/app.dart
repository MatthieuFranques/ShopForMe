

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/navigation_bloc.dart';
import 'ui/screens/home_screen.dart';
import 'config/theme.dart';
import 'utils/screen_utils.dart';

class Shop4MeApp extends StatelessWidget {
  const Shop4MeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBloc()..add(LoadNavigationEvent()),
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
    );
  }
}