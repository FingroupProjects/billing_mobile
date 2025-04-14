import 'dart:io';
import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/clients_by_id/clientById_event.dart';
import 'package:billing_mobile/bloc/clients_by_id/clientById_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientByIdBloc extends Bloc<ClientByIdEvent, ClientByIdState> {
  final ApiService apiService;

  ClientByIdBloc(this.apiService) : super(ClientByIdInitial()) {
    on<FetchClientByIdEvent>(_getClientById);
  }

  Future<void> _getClientById(FetchClientByIdEvent event, Emitter<ClientByIdState> emit) async {
    emit(ClientByIdLoading());

    if (await _checkInternetConnection()) {
      try {
        final response = await apiService.getClientById(event.clientId);
        
        final client = response.client;
        
        emit(ClientByIdLoaded(
          client: client,
          businessTypes: response.businessTypes,
          sales: response.sales,
          tariffs: response.tariffs,
          packs: response.packs,
        ));
      } catch (e) {
        emit(ClientByIdError('Не удалось загрузить данные клиента: ${e.toString()}'));
      }
    } else {
      emit(ClientByIdError('Ошибка подключения к интернету. Проверьте ваше соединение и попробуйте снова.'));
    }
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