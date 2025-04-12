import 'package:billing_mobile/models/clients_model.dart';

abstract class ClientState {}

class ClientInitial extends ClientState {}

class ClientLoading extends ClientState {}

class ClientLoaded extends ClientState {
  final ClientListResponse clientData;

  ClientLoaded(this.clientData);
}

class ClientError extends ClientState {
  final String message;

  ClientError(this.message);
}