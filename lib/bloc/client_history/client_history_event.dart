import 'package:equatable/equatable.dart';

abstract class ClientHistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchClientHistory extends ClientHistoryEvent {
  final int clientId;

  FetchClientHistory(this.clientId);

  @override
  List<Object?> get props => [clientId];
}
