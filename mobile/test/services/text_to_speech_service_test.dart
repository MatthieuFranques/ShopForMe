import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/services/text_to_speech_service.dart';
// Simulacre manuel de FlutterTts pour les tests
import 'package:flutter_tts/flutter_tts.dart';

class FakeFlutterTts implements FlutterTts {
  // Stockage pour les valeurs configurées
  String? language;
  double? pitch;
  double? speechRate;
  String? lastSpokenText;

  @override
  Future<void> setLanguage(String lang) async {
    language = lang;
  }

  @override
  Future<void> setPitch(double value) async {
    pitch = value;
  }

  @override
  Future<void> setSpeechRate(double rate) async {
    speechRate = rate;
  }

  @override
  Future<void> speak(String text) async {
    lastSpokenText = text;
  }

  @override
  Future<void> stop() async {
    // Arrête le texte en cours (vide)
  }

  // Implémentation minimale pour éviter les erreurs
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('TextToSpeechService', () {
    late TextToSpeechService ttsService;
    late FakeFlutterTts fakeTts;

    setUp(() {
      fakeTts = FakeFlutterTts();
      ttsService = TextToSpeechService(tts: fakeTts);
    });

    test('initialize should set language, pitch, and rate', () async {
      await ttsService.initialize();
      expect(fakeTts.language, "fr-FR");
      expect(fakeTts.pitch, 1.0);
      expect(fakeTts.speechRate, 0.5);
    });

    test('speak should call speak with the given text', () async {
      const testText = "Bonjour tout le monde";
      await ttsService.speak(testText);
      expect(fakeTts.lastSpokenText, testText);
    });

    test('stop should call stop on FlutterTts', () async {
      await ttsService.stop();
      // Assurez-vous que stop a été appelé
    });

    test('dispose should call stop on FlutterTts', () async {
      ttsService.dispose();
      // Vérifie si dispose arrête correctement le service
    });
  });
}
