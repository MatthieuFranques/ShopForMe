import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  final FlutterTts flutterTts;

  // Permet l'injection de flutterTts pour les tests
  TextToSpeechService({FlutterTts? tts}) : flutterTts = tts ?? FlutterTts();

  Future<void> initialize() async {
    await flutterTts.setLanguage("fr-FR");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }

  void dispose() {
    flutterTts.stop();
  }
}
