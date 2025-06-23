import 'package:billing_mobile/models/currency_model.dart';
import 'package:equatable/equatable.dart';

abstract class CurrencyState extends Equatable {
  const CurrencyState();

  @override
  List<Object> get props => [];
}

class CurrencyInitialState extends CurrencyState {}

class CurrencyLoadingState extends CurrencyState {}

class CurrencyLoadedState extends CurrencyState {
  final List<CurrencyData> currencies;

  const CurrencyLoadedState(this.currencies);

  @override
  List<Object> get props => [currencies];
}

class CurrencyErrorState extends CurrencyState {
  final String message;

  const CurrencyErrorState(this.message);

  @override
  List<Object> get props => [message];
}