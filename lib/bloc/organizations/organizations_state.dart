import 'package:billing_mobile/models/organizations_model.dart';
import 'package:equatable/equatable.dart';

abstract class OrganizationState extends Equatable {
  const OrganizationState();

  @override
  List<Object> get props => [];
}

class OrganizationInitialState extends OrganizationState {}

class OrganizationLoadingState extends OrganizationState {}

class OrganizationLoadedState extends OrganizationState {
  final List<Organization> organizations;

  const OrganizationLoadedState(this.organizations);

  @override
  List<Object> get props => [organizations];
}

class OrganizationErrorState extends OrganizationState {
  final String message;

  const OrganizationErrorState(this.message);

  @override
  List<Object> get props => [message];
}