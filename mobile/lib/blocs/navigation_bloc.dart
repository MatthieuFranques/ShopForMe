// blocs/navigation_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/store_service.dart';

enum ArrowDirection { nord, sud, est, ouest }

// Navigation Event
abstract class NavigationEvent {}

class LoadNavigationEvent extends NavigationEvent {}

// States
abstract class NavigationState {}

class NavigationInitial extends NavigationState {}

class NavigationLoadedState extends NavigationState {
  final String objectName;
  final String instruction;
  final ArrowDirection arrowDirection;

  NavigationLoadedState({
    required this.objectName,
    required this.instruction,
    required this.arrowDirection,
  });
}

class NavigationLoading extends NavigationState {}

class NavigationError extends NavigationState {
  final String message;
  NavigationError(this.message);
}


// Bloc
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final StoreService _storeService;

  NavigationBloc(this._storeService) : super(NavigationInitial()) {
    on<LoadNavigationEvent>(_onLoadNavigation);
  }
  // TODO Call location_service for navigation
  void _onLoadNavigation(
      LoadNavigationEvent event, Emitter<NavigationState> emit) {
    emit(NavigationLoadedState(
      objectName: "Bananes",
      arrowDirection: ArrowDirection.nord,
      instruction: "Faites 3 pas vers la gauche",
    ));
  }
}