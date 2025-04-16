import 'package:billing_mobile/models/client_history_model.dart';
import 'package:equatable/equatable.dart';

abstract class ClientHistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ClientHistoryInitial extends ClientHistoryState {}

class ClientHistoryLoading extends ClientHistoryState {}

class ClientHistoryLoaded extends ClientHistoryState {
  final List<History> clientHistory;

  ClientHistoryLoaded(this.clientHistory);

  @override
  List<Object?> get props => [clientHistory];
}

class ClientHistoryError extends ClientHistoryState {
  final String message;

  ClientHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
