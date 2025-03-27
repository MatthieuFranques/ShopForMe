import 'package:equatable/equatable.dart';
import 'package:mobile/services/navigation/direction_service.dart';

abstract class NavigationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NavigationInitial extends NavigationState {}

class NavigationLoading extends NavigationState {}

class NavigationLoadedState extends NavigationState {
  final String objectName;
  final String instruction;
  final ArrowDirection arrowDirection;
  final bool isLastProduct;
  final bool isDone;

  NavigationLoadedState({
    required this.objectName,
    required this.instruction,
    required this.arrowDirection,
    this.isLastProduct = false,
    this.isDone = false,
  });

  @override
  List<Object?> get props => [objectName, instruction, arrowDirection, isLastProduct, isDone];
}

class NavigationError extends NavigationState {
  final String message;
  NavigationError(this.message);

  @override
  List<Object?> get props => [message];
}
