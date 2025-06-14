import 'dart:io';
import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/clients_demo/demo_clients_event.dart';
import 'package:billing_mobile/bloc/clients_demo/demo_clients_state.dart';
import 'package:billing_mobile/models/clients_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DemoBloc extends Bloc<DemoEvent, DemoState> {
  final ApiService apiService;
  int _currentPage = 1;
  bool _isFetchingMore = false;
  Map<String, dynamic> _currentFilters = {};
  String _currentSearchQuery = '';

  DemoBloc({required this.apiService}) : super(DemoInitial()) {
    on<FetchDemo>(_onFetchDemo);
    on<FetchMoreDemo>(_onFetchMoreDemo);
    on<DemoApplyFilters>(_onDemoApplyFilters);
    on<SearchDemo>(_onSearchDemo);
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  Future<void> _onFetchDemo(FetchDemo event, Emitter<DemoState> emit) async {
  emit(DemoLoading());
  if (!await _checkInternetConnection()) {
    emit(DemoError('Нет подключения к интернету'));
    return;
  }
  
  try {
    _currentPage = 1;
    final demoData = await apiService.getDemoClients(
      page: _currentPage,
      search: _currentSearchQuery,
      demo: _currentFilters['demo'],
      status: _currentFilters['status'],
      tariff: _currentFilters['tariff'],
      partner: _currentFilters['partner'],
        countryId: _currentFilters['country_id'], // Added country_id filter
          currencyId: _currentFilters['currency_id'], // Added currency_id filter 
    );
    emit(DemoLoaded(demoData, isLoadingMore: false));
  } catch (e) {
    emit(DemoError(e.toString()));
  }
}

Future<void> _onFetchMoreDemo(FetchMoreDemo event, Emitter<DemoState> emit) async {
  if (_isFetchingMore) return;
  _isFetchingMore = true;

  if (!await _checkInternetConnection()) {
    emit(DemoError('Нет подключения к интернету'));
    _isFetchingMore = false;
    return;
  }

  if (state is DemoLoaded) {
    final currentState = state as DemoLoaded;
    if (currentState.clientData.data.clients.currentPage >= currentState.clientData.data.clients.total ~/ 20 + 1) {
      _isFetchingMore = false;
      return;
    }

    try {
      emit(DemoLoaded(currentState.clientData, isLoadingMore: true));
      final nextPageData = await apiService.getClients(
        page: _currentPage + 1,
        search: _currentSearchQuery, 
        demo: _currentFilters['demo'],
        status: _currentFilters['status'],
        tariff: _currentFilters['tariff'],
        partner: _currentFilters['partner'],
         countryId: _currentFilters['country_id'], // Added country_id filter
        currencyId: _currentFilters['currency_id'], // Added currency_id filter
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
      emit(DemoLoaded(updatedResponse, isLoadingMore: false));
    } catch (e) {
      emit(DemoError(e.toString()));
    } finally {
      _isFetchingMore = false;
    }
  }
}

  Future<void> _onDemoApplyFilters(DemoApplyFilters event, Emitter<DemoState> emit) async {
    _currentFilters = event.filters;
    add(FetchDemo());
  }

  Future<void> _onSearchDemo(SearchDemo event, Emitter<DemoState> emit) async {
    _currentSearchQuery = event.query;
    add(FetchDemo());
  }
  
}