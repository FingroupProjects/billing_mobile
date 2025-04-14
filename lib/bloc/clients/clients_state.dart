import 'package:billing_mobile/models/clients_model.dart';

abstract class ClientState {}

class ClientInitial extends ClientState {}

class ClientLoading extends ClientState {}

class ClientLoaded extends ClientState {
  final ClientListResponse clientData;
  final bool isLoadingMore;

  ClientLoaded(this.clientData, {this.isLoadingMore = false});
}

class ClientSuccess extends ClientState {
  final String message;

  ClientSuccess(this.message);
}

class ClientError extends ClientState {
  final String message;

  ClientError(this.message);
}