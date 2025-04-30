import 'package:billing_mobile/models/clients_model.dart';

abstract class InActiveState {}

class InActiveInitial extends InActiveState {}

class InActiveLoading extends InActiveState {}

class InActiveLoaded extends InActiveState {
  final ClientListResponse clientData;
  final bool isLoadingMore;

  InActiveLoaded(this.clientData, {this.isLoadingMore = false});
}

class InActiveSuccess extends InActiveState {
  final String message;

  InActiveSuccess(this.message);
}

class InActiveError extends InActiveState {
  final String message;

  InActiveError(this.message);
}