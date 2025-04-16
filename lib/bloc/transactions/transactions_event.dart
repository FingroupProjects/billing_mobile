import 'package:equatable/equatable.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class FetchTransactionEvent extends TransactionEvent {
  final String clientId;

  const FetchTransactionEvent(this.clientId);
}

