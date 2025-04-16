abstract class TransactionEvent {}

class FetchTransactionEvent extends TransactionEvent {
  final String clientId;

  FetchTransactionEvent(this.clientId);
}

class FetchMoreTransactionsEvent extends TransactionEvent {
  final String clientId;

  FetchMoreTransactionsEvent(this.clientId);
}