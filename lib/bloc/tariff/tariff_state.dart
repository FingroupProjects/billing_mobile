import 'package:billing_mobile/models/tariff_model.dart';
import 'package:equatable/equatable.dart';

abstract class TariffState extends Equatable {
  const TariffState();

  @override
  List<Object> get props => [];
}

class TariffInitialState extends TariffState {}

class TariffLoadingState extends TariffState {}

class TariffLoadedState extends TariffState {
  final List<TariffData> tariffs;

  const TariffLoadedState(this.tariffs);

  @override
  List<Object> get props => [tariffs];
}

class TariffErrorState extends TariffState {
  final String message;

  const TariffErrorState(this.message);

  @override
  List<Object> get props => [message];
}