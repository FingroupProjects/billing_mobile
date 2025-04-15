import 'package:billing_mobile/models/organizations_model.dart';
import 'package:equatable/equatable.dart';

abstract class OrganizationByIdState extends Equatable {
  const OrganizationByIdState();

  @override
  List<Object> get props => [];
}

class OrganizationByIdInitialState extends OrganizationByIdState {}

class OrganizationByIdLoading extends OrganizationByIdState {}

class OrganizationByIdLoaded extends OrganizationByIdState {
  final List<Organization> organizations;

  const OrganizationByIdLoaded(this.organizations);

}

class OrganizationSuccess extends OrganizationByIdState {
  final String message;

  OrganizationSuccess(this.message);
}

class OrganizationByIdError extends OrganizationByIdState {
  final String message;

const OrganizationByIdError(this.message);
}
