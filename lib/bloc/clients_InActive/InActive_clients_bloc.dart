import 'dart:io';
import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/clients_InActive/InActive_clients_event.dart';
import 'package:billing_mobile/bloc/clients_InActive/InActive_clients_state.dart';
import 'package:billing_mobile/models/clients_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InActiveBloc extends Bloc<InActiveEvent, InActiveState> {
  final ApiService apiService;
  int _currentPage = 1;
  bool _isFetchingMore = false;
  Map<String, dynamic> _currentFilters = {};
  String _currentSearchQuery = '';

  InActiveBloc({required this.apiService}) : super(InActiveInitial()) {
    on<FetchInActive>(_onFetchInActive);
    on<FetchMoreInActive>(_onFetchMoreInActive);
    on<InActiveApplyFilters>(_onInActiveApplyFilters);
    on<SearchInActive>(_onSearchInActive);
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  Future<void> _onFetchInActive(FetchInActive event, Emitter<InActiveState> emit) async {
  emit(InActiveLoading());
  if (!await _checkInternetConnection()) {
    emit(InActiveError('Нет подключения к интернету'));
    return;
  }
  
  try {
    _currentPage = 1;
    final clientData = await apiService.getInActiveClients(
      page: _currentPage,
      search: _currentSearchQuery,
      demo: _currentFilters['demo'],
      status: _currentFilters['status'],
      tariff: _currentFilters['tariff'],
      partner: _currentFilters['partner'],
    );
    emit(InActiveLoaded(clientData, isLoadingMore: false));
  } catch (e) {
    emit(InActiveError(e.toString()));
  }
}

Future<void> _onFetchMoreInActive(FetchMoreInActive event, Emitter<InActiveState> emit) async {
  if (_isFetchingMore) return;
  _isFetchingMore = true;

  if (!await _checkInternetConnection()) {
    emit(InActiveError('Нет подключения к интернету'));
    _isFetchingMore = false;
    return;
  }

  if (state is InActiveLoaded) {
    final currentState = state as InActiveLoaded;
    if (currentState.clientData.data.clients.currentPage >= currentState.clientData.data.clients.total ~/ 20 + 1) {
      _isFetchingMore = false;
      return;
    }

    try {
      emit(InActiveLoaded(currentState.clientData, isLoadingMore: true));
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
      emit(InActiveLoaded(updatedResponse, isLoadingMore: false));
    } catch (e) {
      emit(InActiveError(e.toString()));
    } finally {
      _isFetchingMore = false;
    }
  }
}

  Future<void> _onInActiveApplyFilters(InActiveApplyFilters event, Emitter<InActiveState> emit) async {
    _currentFilters = event.filters;
    add(FetchInActive());
  }

  Future<void> _onSearchInActive(SearchInActive event, Emitter<InActiveState> emit) async {
    _currentSearchQuery = event.query;
    add(FetchInActive());
  }

}