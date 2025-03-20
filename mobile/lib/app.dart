import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/product_search/product_search_export.dart';
import 'package:mobile/blocs/shopping_list/shopping_list_export.dart';
import 'package:mobile/blocs/tts/tts_bloc.dart'; // Import du Bloc TTS
import 'package:mobile/services/text_to_speech_service.dart'; // Import du service TTS
import 'ui/screens/home_screen.dart';
import 'config/theme.dart';
import 'utils/screen_utils.dart';

class Shop4MeApp extends StatelessWidget {
  const Shop4MeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductSearchBloc()),
        BlocProvider(
            create: (context) => ShoppingListBloc()..add(LoadShoppingList())),
        BlocProvider(create: (context) => TtsBloc(TextToSpeechService())),
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
    );
  }
}
