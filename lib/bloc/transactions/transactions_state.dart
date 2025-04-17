import 'package:billing_mobile/models/transactions_model.dart';
import 'package:equatable/equatable.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionInitialState extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final TransactionListResponse transactionData;
  final bool isLoadingMore;

  const TransactionLoaded(this.transactionData, {this.isLoadingMore = false});

  @override
  List<Object> get props => [transactionData, isLoadingMore];
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object> get props => [message];
}

class TransactionCreated extends TransactionState {
  final String message;

const TransactionCreated(this.message);

}

class TransactionCreateError extends TransactionState {
  final String message;

const TransactionCreateError(this.message);
}