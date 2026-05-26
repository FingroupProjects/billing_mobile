import 'package:billing_mobile/models/organizations_model.dart';
import 'package:equatable/equatable.dart';

abstract class OrganizationByIdState extends Equatable {
  const OrganizationByIdState();

  @override
  List<Object> get props => [];
}

class OrganizationByIdInitialState extends OrganizationByIdState {
  const OrganizationByIdInitialState();
}

class OrganizationByIdLoading extends OrganizationByIdState {
  const OrganizationByIdLoading();
}

class OrganizationByIdLoaded extends OrganizationByIdState {
  final OrganizationDetails organizationDetails;

  const OrganizationByIdLoaded(this.organizationDetails);

  @override
  List<Object> get props => [organizationDetails];
}

class OrganizationSuccess extends OrganizationByIdState {
  final String message;

  const OrganizationSuccess(this.message);
}

class OrganizationByIdError extends OrganizationByIdState {
  final String message;

  const OrganizationByIdError(this.message);

  @override
  List<Object> get props => [message];
}
