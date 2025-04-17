import 'package:equatable/equatable.dart';

abstract class OrganizationEvent extends Equatable {
  const OrganizationEvent();

  @override
  List<Object> get props => [];
}

class FetchOrganizationEvent extends OrganizationEvent {
  final String clientId;

  const FetchOrganizationEvent(this.clientId);

  @override
  List<Object> get props => [clientId];
}

class ResetOrganizationEvent extends OrganizationEvent {}

class CreateOrganizations extends OrganizationEvent {
  final int clientId;
  final String name;
  final String phone;
  final String inn;
  final String businessTypeId;
  final String address;   

  CreateOrganizations({
    required this.clientId,
    required this.name,
    required this.phone,
    required this.inn,
    required this.businessTypeId,
    required this.address,
  });
}