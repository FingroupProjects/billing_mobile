import 'package:equatable/equatable.dart';

abstract class OrganizationByIdEvent extends Equatable {
  const OrganizationByIdEvent();

  @override
  List<Object> get props => [];
}

class FetchOrganizationByIdEvent extends OrganizationByIdEvent {
  final String organizationId;

  const FetchOrganizationByIdEvent(this.organizationId);

  @override
  List<Object> get props => [organizationId];
}

