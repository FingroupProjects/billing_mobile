import 'dart:io';

import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/transactions/transactions_event.dart';
import 'package:billing_mobile/bloc/transactions/transactions_state.dart';
import 'package:bloc/bloc.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final ApiService apiService;

  TransactionBloc({required this.apiService}) : super(TransactionInitialState()) {
    on<FetchTransactionEvent>(_fetchTransaction);
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }
  
  Future<void> _fetchTransaction( FetchTransactionEvent event, Emitter<TransactionState> emit ) async {
    emit(TransactionLoading());
    
    final hasConnection = await _checkInternetConnection();
    if (!hasConnection) {
      emit(TransactionError('Нет интернет соединения!'));
      return;
    }
    
    try {
      final transactions = await apiService.getClientByIdTransactions(event.clientId);
      if (transactions.isEmpty) {
        // emit(TransactionEmpty()); 
      } else {
        emit(TransactionLoaded(transactions));
      }
    } catch (e) {
      emit(TransactionError('Failed to load Transactions: $e'));
    }
  }
}