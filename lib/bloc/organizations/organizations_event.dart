import 'package:equatable/equatable.dart';

abstract class OrganizationEvent extends Equatable {
  const OrganizationEvent();

  @override
  List<Object> get props => [];
}

class LoadOrganizationEvent extends OrganizationEvent {
  final String clientId;

  const LoadOrganizationEvent(this.clientId);

  @override
  List<Object> get props => [clientId];
}

class ResetOrganizationEvent extends OrganizationEvent {}