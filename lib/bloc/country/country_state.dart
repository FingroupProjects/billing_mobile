import 'package:billing_mobile/models/Country_model.dart';
import 'package:equatable/equatable.dart';

abstract class CountryState extends Equatable {
  const CountryState();

  @override
  List<Object> get props => [];
}

class CountryInitialState extends CountryState {}

class CountryLoadingState extends CountryState {}

class CountryLoadedState extends CountryState {
  final List<CountryData> countries;

  const CountryLoadedState(this.countries);

  @override
  List<Object> get props => [countries];
}

class CountryErrorState extends CountryState {
  final String message;

  const CountryErrorState(this.message);

  @override
  List<Object> get props => [message];
}