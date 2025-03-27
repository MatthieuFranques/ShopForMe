import 'package:equatable/equatable.dart';

// Events
abstract class ProductSearchEvent extends Equatable {
  const ProductSearchEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductSearchEvent {}

class SearchProducts extends ProductSearchEvent {
  final String query;
  const SearchProducts(this.query);

  @override
  List<Object> get props => [query];
}