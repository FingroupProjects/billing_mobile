import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/clients/clients_event.dart';
import 'package:billing_mobile/bloc/clients/clients_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  final ApiService apiService;

  ClientBloc({required this.apiService}) : super(ClientInitial()) {
    on<FetchClients>(_onFetchClients);
  }

  Future<void> _onFetchClients(
    FetchClients event,
    Emitter<ClientState> emit,
  ) async {
    emit(ClientLoading());
    try {
      final clientData = await apiService.getClients();
      emit(ClientLoaded(clientData));
    } catch (e) {
      emit(ClientError(e.toString()));
    }
  }
}