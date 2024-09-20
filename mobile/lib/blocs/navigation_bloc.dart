import 'package:flutter_bloc/flutter_bloc.dart';

// Define the possible directions for the arrow
enum ArrowDirection { left, right }

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

  void _onLoadNavigation(LoadNavigationEvent event, Emitter<NavigationState> emit) {
    // Simulate loading data
    emit(NavigationLoadedState(
      objectName: "Chaise",
      arrowDirection: ArrowDirection.left,
      instruction: "Faites 3 pas vers la gauche",
    ));
  }
}
