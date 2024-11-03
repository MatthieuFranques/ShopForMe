// blocs/navigation_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/store_service.dart';

// Events
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

enum ArrowDirection { left, right }

// Bloc
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final StoreService _storeService;

  NavigationBloc(this._storeService) : super(NavigationInitial()) {
    on<LoadNavigationEvent>(_onLoadNavigation);
  }

  Future<void> _onLoadNavigation(
    LoadNavigationEvent event,
    Emitter<NavigationState> emit,
  ) async {
    try {
      emit(NavigationLoading());
      
      // Pour le moment, on émet un état chargé basique
      // À adapter selon vos besoins de navigation
      emit(NavigationLoadedState(
        objectName: "Premier produit",
        instruction: "Tournez à gauche",
        arrowDirection: ArrowDirection.left,
      ));
      
    } catch (e) {
      emit(NavigationError(e.toString()));
    }
  }
}