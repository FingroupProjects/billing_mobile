import 'dart:io';
import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/clients/clients_event.dart';
import 'package:billing_mobile/bloc/clients/clients_state.dart';
import 'package:billing_mobile/models/clients_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  final ApiService apiService;
  int _currentPage = 1;
  bool _isFetchingMore = false;
  Map<String, dynamic> _currentFilters = {};
  String _currentSearchQuery = '';

  ClientBloc({required this.apiService}) : super(ClientInitial()) {
    on<FetchClients>(_onFetchClients);
    on<FetchMoreClients>(_onFetchMoreClients);
    on<CreateClients>(_createClients);
    on<ApplyFilters>(_onApplyFilters);
    on<SearchClients>(_onSearchClients);
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  Future<void> _onFetchClients(FetchClients event, Emitter<ClientState> emit) async {
    emit(ClientLoading());
    try {
      _currentPage = 1;
      final clientData = await apiService.getClients(
        page: _currentPage,
        search: _currentSearchQuery,
        demo: _currentFilters['demo'],
        status: _currentFilters['status'],
        tariff: _currentFilters['tariff'],
        partner: _currentFilters['partner'],
      );
      emit(ClientLoaded(clientData, isLoadingMore: false));
    } catch (e) {
      emit(ClientError(e.toString()));
    }
  }

   Future<void> _onFetchMoreClients(FetchMoreClients event, Emitter<ClientState> emit) async {
  if (_isFetchingMore) return;
  _isFetchingMore = true;

  if (state is ClientLoaded) {
    final currentState = state as ClientLoaded;
    if (currentState.clientData.data.clients.currentPage >= currentState.clientData.data.clients.total ~/ 20 + 1) {
      _isFetchingMore = false;
      return;
    }

    try {
      emit(ClientLoaded(currentState.clientData, isLoadingMore: true));
      final nextPageData = await apiService.getClients(
        page: _currentPage + 1,
        search: _currentSearchQuery, 
        demo: _currentFilters['demo'],
        status: _currentFilters['status'],
        tariff: _currentFilters['tariff'],
        partner: _currentFilters['partner'],
      );
      
      final updatedClients = ClientList(
        currentPage: nextPageData.data.clients.currentPage,
        data: [...currentState.clientData.data.clients.data, ...nextPageData.data.clients.data],
        total: nextPageData.data.clients.total,
      );
      
      final updatedData = ClientData(
        clients: updatedClients,
        tariffs: currentState.clientData.data.tariffs,
      );
      
      final updatedResponse = ClientListResponse(
        view: currentState.clientData.view,
        data: updatedData,
      );
      
      _currentPage++;
      emit(ClientLoaded(updatedResponse, isLoadingMore: false));
    } catch (e) {
      emit(ClientError(e.toString()));
    } finally {
      _isFetchingMore = false;
    }
  }
}

  Future<void> _onApplyFilters(ApplyFilters event, Emitter<ClientState> emit) async {
    _currentFilters = event.filters;
    add(FetchClients());
  }

  Future<void> _onSearchClients(SearchClients event, Emitter<ClientState> emit) async {
    _currentSearchQuery = event.query;
    add(FetchClients());
  }

  Future<void> _createClients(CreateClients event, Emitter<ClientState> emit) async {
    emit(ClientLoading());
    if (await _checkInternetConnection()) {
      try {
        final result = await apiService.createClients(
          fio: event.fio,
          phone: event.phone,
          email: event.email,
          contactPerson: event.contactPerson,
          subDomain: event.subDomain,
          partnerId: event.partnerid,
          clientType: event.clientType,
          tariffId: event.tarrifId,
          saleId: event.saleId,
          countryId: event.countryId,
          isDemo: event.isDemo,
        );

        if (result['success']) {
          emit(ClientSuccess('Клиент успешно создан!'));
          add(FetchClients());
        } else {
          emit(ClientError(result['message']));
          add(FetchClients());
        }
      } catch (e) {
        emit(ClientError('Ошибка создания клиента!'));
      }
    } else {
      emit(ClientError('Нет подключения к интернету'));
    }
  }
}