import 'package:equatable/equatable.dart';

abstract class TariffEvent extends Equatable {
  const TariffEvent();

  @override
  List<Object> get props => [];
}

class LoadTariffEvent extends TariffEvent {
  final String code; // Added code parameter

  const LoadTariffEvent(this.code);

  @override
  List<Object> get props => [code];
}

class ResetTariffEvent extends TariffEvent {}