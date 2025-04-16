import 'dart:io';
import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/transactionsById/transactionsById_event.dart';
import 'package:billing_mobile/bloc/transactionsById/transactionsById_state.dart';
import 'package:bloc/bloc.dart';

class TransactionByIdBloc extends Bloc<TransactionByIdEvent, TransactionByIdState> {
  final ApiService apiService;

  TransactionByIdBloc({required this.apiService}) : super(TransactionByIdInitialState()) {
    on<FetchTransactionByIdEvent>(_fetchTransactionById);

  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

Future<void> _fetchTransactionById( FetchTransactionByIdEvent event, Emitter<TransactionByIdState> emit ) async { emit(TransactionByIdLoading());
 
  final hasConnection = await _checkInternetConnection();
    if (!hasConnection) {
      emit(TransactionByIdError('Нет интернет соединения!'));
      return;
    }

  try {
    final transactions = await apiService.getTransactionsById(event.transactionId);
    if (transactions.isEmpty) {
      // emit(OrganizationError('No transactions found'));
    } else {
      emit(TransactionByIdLoaded(transactions));
    }
  } catch (e) {
    emit(TransactionByIdError('Failed to load organizationsByID: $e'));
  }
}
}