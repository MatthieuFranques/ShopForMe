import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> initialize() async {
    // Configurations de base pour la voix (optionnel)
    await _flutterTts.setLanguage("fr-FR");
    await _flutterTts.setPitch(1.0); // Ton de la voix
    await _flutterTts.setSpeechRate(0.5); // Vitesse de la voix
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  void dispose() {
    _flutterTts.stop();
  }
}
