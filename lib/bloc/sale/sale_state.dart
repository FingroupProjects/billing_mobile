import 'package:billing_mobile/models/sale_model.dart';
import 'package:equatable/equatable.dart';

abstract class SaleState extends Equatable {
  const SaleState();

  @override
  List<Object> get props => [];
}

class SaleInitialState extends SaleState {}

class SaleLoadingState extends SaleState {}

class SaleLoadedState extends SaleState {
  final List<SaleData> sales;

  const SaleLoadedState(this.sales);

  @override
  List<Object> get props => [sales];
}

class SaleErrorState extends SaleState {
  final String message;

  const SaleErrorState(this.message);

  @override
  List<Object> get props => [message];
}