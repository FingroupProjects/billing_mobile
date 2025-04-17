abstract class TransactionEvent {}

class FetchTransactionEvent extends TransactionEvent {
  final String clientId;

  FetchTransactionEvent(this.clientId);
}

class FetchMoreTransactionsEvent extends TransactionEvent {
  final String clientId;

  FetchMoreTransactionsEvent(this.clientId);
}

class CreateTransactions extends TransactionEvent {
  final int clientId;
  final String date;
  final String sum;

  CreateTransactions({
    required this.clientId,
    required this.date,
    required this.sum,
  });
}