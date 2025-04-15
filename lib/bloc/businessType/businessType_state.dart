import 'package:billing_mobile/models/businessType_model.dart';
import 'package:equatable/equatable.dart';

abstract class BusinessTypeState extends Equatable {
  const BusinessTypeState();

  @override
  List<Object> get props => [];
}

class BusinessTypeInitialState extends BusinessTypeState {}

class BusinessTypeLoadingState extends BusinessTypeState {}

class BusinessTypeLoadedState extends BusinessTypeState {
  final List<BusinessTypeData> businessTypes;

  const BusinessTypeLoadedState(this.businessTypes);

  @override
  List<Object> get props => [businessTypes];
}

class BusinessTypeErrorState extends BusinessTypeState {
  final String message;

  const BusinessTypeErrorState(this.message);

  @override
  List<Object> get props => [message];
}