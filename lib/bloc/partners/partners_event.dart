import 'package:equatable/equatable.dart';

abstract class PartnerEvent extends Equatable {
  const PartnerEvent();

  @override
  List<Object> get props => [];
}

class LoadPartnerEvent extends PartnerEvent {}

class ResetPartnerEvent extends PartnerEvent {}