import 'package:billing_mobile/models/organizations_model.dart';
import 'package:equatable/equatable.dart';

abstract class OrganizationState extends Equatable {
  const OrganizationState();

  @override
  List<Object> get props => [];
}

class OrganizationInitialState extends OrganizationState {}

class OrganizationLoading extends OrganizationState {}

class OrganizationLoaded extends OrganizationState {
  final List<Organization> organizations;

  const OrganizationLoaded(this.organizations);

  @override
  List<Object> get props => [organizations];
}

class OrganizationSuccess extends OrganizationState {
  final String message;

  OrganizationSuccess(this.message);
}

class OrganizationCreated extends OrganizationState {
  final String message;

const OrganizationCreated(this.message);

}
class OrganizationUpdated extends OrganizationState {
  final String message;

const OrganizationUpdated(this.message);

}

class OrganizationError extends OrganizationState {
  final String message;

const OrganizationError(this.message);
}
class OrganizationCreateError extends OrganizationState {
  final String message;

const OrganizationCreateError(this.message);
}
class OrganizationUpdateError extends OrganizationState {
  final String message;

const OrganizationUpdateError(this.message);
}