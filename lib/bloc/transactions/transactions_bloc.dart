import 'dart:io';

import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/transactions/transactions_event.dart';
import 'package:billing_mobile/bloc/transactions/transactions_state.dart';
import 'package:billing_mobile/models/transactions_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final ApiService apiService;
  int _currentPage = 1;
  bool _isFetchingMore = false;

  TransactionBloc({required this.apiService}) : super(TransactionInitialState()) {
    on<FetchTransactionEvent>(_onFetchTransactions);
    on<FetchMoreTransactionsEvent>(_onFetchMoreTransactions);
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  Future<void> _onFetchTransactions(FetchTransactionEvent event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    final hasConnection = await _checkInternetConnection();
    if (!hasConnection) {
      emit(TransactionError('Нет интернет соединения!'));
      return;
    }

    try {
      _currentPage = 1;
      final transactionData = await apiService.getClientByIdTransactions(event.clientId, page: _currentPage);
      emit(TransactionLoaded(transactionData, isLoadingMore: false));
    } catch (e) {
      emit(TransactionError('Ошибка загрузки транзакций!'));
    }
  }

  Future<void> _onFetchMoreTransactions(FetchMoreTransactionsEvent event, Emitter<TransactionState> emit) async {
    if (_isFetchingMore) return;
    _isFetchingMore = true;

    if (state is TransactionLoaded) {
      final currentState = state as TransactionLoaded;
      if (currentState.transactionData.data.currentPage >= currentState.transactionData.data.lastPage) {
        _isFetchingMore = false;
        return;
      }

      try {
        emit(TransactionLoaded(currentState.transactionData, isLoadingMore: true));
        final nextPageData = await apiService.getClientByIdTransactions(event.clientId, page: _currentPage + 1);
        final updatedTransactions = TransactionList(
          currentPage: nextPageData.data.currentPage,
          lastPage: nextPageData.data.lastPage,
          data: [...currentState.transactionData.data.data, ...nextPageData.data.data],
          total: nextPageData.data.total,
        );
        final updatedResponse = TransactionListResponse(
          view: currentState.transactionData.view,
          data: updatedTransactions,
        );
        _currentPage++;
        emit(TransactionLoaded(updatedResponse, isLoadingMore: false));
      } catch (e) {
        emit(TransactionError('Ошибка загрузки дополнительных транзакций!'));
      } finally {
        _isFetchingMore = false;
      }
    }
  }
}