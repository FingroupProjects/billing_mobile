import 'package:billing_mobile/models/partner_model.dart';
import 'package:equatable/equatable.dart';

abstract class PartnerState extends Equatable {
  const PartnerState();

  @override
  List<Object> get props => [];
}

class PartnerInitialState extends PartnerState {}

class PartnerLoadingState extends PartnerState {}

class PartnerLoadedState extends PartnerState {
  final List<Partner> partners;

  const PartnerLoadedState(this.partners);

  @override
  List<Object> get props => [partners];
}

class PartnerErrorState extends PartnerState {
  final String message;

  const PartnerErrorState(this.message);

  @override
  List<Object> get props => [message];
}