import 'package:flutter_bloc/flutter_bloc.dart';

enum ArrowDirection { Nord, Sud, Est, Ouest }

// Navigation Event
abstract class NavigationEvent {}

class LoadNavigationEvent extends NavigationEvent {}

// Navigation State
abstract class NavigationState {}

class NavigationLoadingState extends NavigationState {}

class NavigationLoadedState extends NavigationState {
  final String objectName;
  final ArrowDirection arrowDirection;
  final String instruction;

  NavigationLoadedState({
    required this.objectName,
    required this.arrowDirection,
    required this.instruction,
  });
}

// Navigation BLoC
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationLoadingState()) {
    on<LoadNavigationEvent>(_onLoadNavigation);
  }
  // TODO Call location_service for navigation
  void _onLoadNavigation(
      LoadNavigationEvent event, Emitter<NavigationState> emit) {
    emit(NavigationLoadedState(
      objectName: "Bananes",
      arrowDirection: ArrowDirection.Nord,
      instruction: "Faites 3 pas vers la gauche",
    ));
  }
}
