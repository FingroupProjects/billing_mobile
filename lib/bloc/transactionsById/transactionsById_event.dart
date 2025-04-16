import 'package:equatable/equatable.dart';

abstract class TransactionByIdEvent extends Equatable {
  const TransactionByIdEvent();

  @override
  List<Object> get props => [];
}

class FetchTransactionByIdEvent extends TransactionByIdEvent {
  final String transactionId;

  const FetchTransactionByIdEvent(this.transactionId);

  @override
  List<Object> get props => [transactionId];
}

