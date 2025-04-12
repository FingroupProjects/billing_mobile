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
        // 1. Get the full response
        final response = await apiService.getClientById(event.clientId);
        
        // 2. Extract the client and related data
        final client = response.client;
        
        // 3. Emit the loaded state with all necessary data
        emit(ClientByIdLoaded(
          client: client,
          businessTypes: response.businessTypes,
          sales: response.sales,
          tariffs: response.tariffs,
          packs: response.packs,
        ));
      } catch (e) {
        // 4. Provide more detailed error message
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