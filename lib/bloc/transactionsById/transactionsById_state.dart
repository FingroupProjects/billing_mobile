import 'package:billing_mobile/models/transactions_model.dart';
import 'package:equatable/equatable.dart';

abstract class TransactionByIdState extends Equatable {
  const TransactionByIdState();

  @override
  List<Object> get props => [];
}

class TransactionByIdInitialState extends TransactionByIdState {}

class TransactionByIdLoading extends TransactionByIdState {}

class TransactionByIdLoaded extends TransactionByIdState {
  final List<Transaction> transactions;

  const TransactionByIdLoaded(this.transactions);

}

class TransactionByIdError extends TransactionByIdState {
  final String message;

const TransactionByIdError(this.message);
}
