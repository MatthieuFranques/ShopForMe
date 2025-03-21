import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/services/text_to_speech_service.dart';

// 📌 Événements du Bloc
abstract class TtsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TtsSpeak extends TtsEvent {
  final String text;

  TtsSpeak(this.text);

  @override
  List<Object?> get props => [text];
}

class TtsStop extends TtsEvent {}

//  State Bloc
abstract class TtsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TtsInitial extends TtsState {}

class TtsSpeaking extends TtsState {}

class TtsStopped extends TtsState {}

// Bloc TTS
class TtsBloc extends Bloc<TtsEvent, TtsState> {
  final TextToSpeechService _ttsService;

  TtsBloc(this._ttsService) : super(TtsInitial()) {
    on<TtsSpeak>((event, emit) async {
      emit(TtsSpeaking());
      await _ttsService.speak(event.text);
      emit(TtsStopped());
    });

    on<TtsStop>((event, emit) async {
      await _ttsService.stop();
      emit(TtsStopped());
    });
  }
}
