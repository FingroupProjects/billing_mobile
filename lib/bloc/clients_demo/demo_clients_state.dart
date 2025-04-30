import 'package:billing_mobile/models/clients_model.dart';

abstract class DemoState {}

class DemoInitial extends DemoState {}

class DemoLoading extends DemoState {}

class DemoLoaded extends DemoState {
  final ClientListResponse clientData;
  final bool isLoadingMore;

  DemoLoaded(this.clientData, {this.isLoadingMore = false});
}

class DemoSuccess extends DemoState {
  final String message;

  DemoSuccess(this.message);
}

class DemoError extends DemoState {
  final String message;

  DemoError(this.message);
}