import 'dart:io';

import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/client_history/client_history_event.dart';
import 'package:billing_mobile/bloc/client_history/client_history_state.dart';
import 'package:bloc/bloc.dart';

class ClientHistoryBloc extends Bloc<ClientHistoryEvent, ClientHistoryState> {
  final ApiService apiService;

  ClientHistoryBloc(this.apiService) : super(ClientHistoryInitial()) {
    on<FetchClientHistory>((event, emit) async {
      emit(ClientHistoryLoading());

      if (await _checkInternetConnection()) {
        try {
          final clientHistory = await apiService.getClientHistory(event.clientId);
          emit(ClientHistoryLoaded(clientHistory));
        } catch (e) {
          emit(ClientHistoryError('Ошибка при загрузке истории клиента!'));
        }
      } else {
        emit(ClientHistoryError('Ошибка подключения к интернету. Проверьте ваше соединение и попробуйте снова.'));
      }
    });
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }
}
