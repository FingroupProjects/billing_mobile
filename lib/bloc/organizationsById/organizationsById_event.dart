import 'package:equatable/equatable.dart';

abstract class OrganizationByIdEvent extends Equatable {
  const OrganizationByIdEvent();

  @override
  List<Object> get props => [];
}

class FetchOrganizationByIdEvent extends OrganizationByIdEvent {
  final String clientId;

  const FetchOrganizationByIdEvent(this.clientId);

  @override
  List<Object> get props => [clientId];
}

