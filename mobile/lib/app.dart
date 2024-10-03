import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/navigation_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'ui/screens/home_screen.dart';
import 'config/theme.dart';
// import 'package:mobile/blocs/navigation_bloc.dart';
// import 'package:mobile/ui/screens/navigation_screen.dart';

// class Shop4MeApp extends StatelessWidget {
//   const Shop4MeApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Shop4Me',
//       theme: Shop4MeTheme.lightTheme,
//       home: const HomeScreen(),
//     );
//   }
// }
class Shop4MeApp extends StatelessWidget {
  const Shop4MeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop4Me',
      theme: Shop4MeTheme.getTheme(fontSize: FontSize.medium),
      home: const HomeScreen(),
    );
  }
}
