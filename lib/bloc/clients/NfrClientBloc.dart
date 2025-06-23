import 'dart:io';
import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/models/clients_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class NfrClientEvent {}

class FetchNfrClients extends NfrClientEvent {}

class FetchMoreNfrClients extends NfrClientEvent {}

class ApplyNfrFilters extends NfrClientEvent {
  final Map<String, dynamic> filters;
  ApplyNfrFilters(this.filters);
}

class SearchNfrClients extends NfrClientEvent {
  final String query;
  SearchNfrClients(this.query);
}

// States
abstract class NfrClientState {}

class NfrClientInitial extends NfrClientState {}

class NfrClientLoading extends NfrClientState {}

class NfrClientLoaded extends NfrClientState {
  final ClientListResponse clientData;
  final bool isLoadingMore;
  NfrClientLoaded(this.clientData, {this.isLoadingMore = false});
}

class NfrClientError extends NfrClientState {
  final String message;
  NfrClientError(this.message);
}

// BLoC
class NfrClientBloc extends Bloc<NfrClientEvent, NfrClientState> {
  final ApiService apiService;
  int _currentPage = 1;
  bool _isFetchingMore = false;
  Map<String, dynamic> _currentFilters = {};
  String _currentSearchQuery = '';

  NfrClientBloc({required this.apiService}) : super(NfrClientInitial()) {
    on<FetchNfrClients>(_onFetchNfrClients);
    on<FetchMoreNfrClients>(_onFetchMoreNfrClients);
    on<ApplyNfrFilters>(_onApplyNfrFilters);
    on<SearchNfrClients>(_onSearchNfrClients);
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  Future<void> _onFetchNfrClients(FetchNfrClients event, Emitter<NfrClientState> emit) async {
    emit(NfrClientLoading());
    if (!await _checkInternetConnection()) {
      emit(NfrClientError('Нет подключения к интернету'));
      return;
    }

    try {
      _currentPage = 1;
      final clientData = await apiService.getNfrClients(
        page: _currentPage,
        search: _currentSearchQuery,
        demo: _currentFilters['demo'],
        status: _currentFilters['status'],
        tariff: _currentFilters['tariff'],
        partner: _currentFilters['partner'],
          countryId: _currentFilters['country_id'], // Added country_id filter
        currencyId: _currentFilters['currency_id'], // Added currency_id filter
      );
      emit(NfrClientLoaded(clientData, isLoadingMore: false));
    } catch (e) {
      emit(NfrClientError(e.toString()));
    }
  }

  Future<void> _onFetchMoreNfrClients(FetchMoreNfrClients event, Emitter<NfrClientState> emit) async {
    if (_isFetchingMore) return;
    _isFetchingMore = true;

    if (!await _checkInternetConnection()) {
      emit(NfrClientError('Нет подключения к интернету'));
      _isFetchingMore = false;
      return;
    }

    if (state is NfrClientLoaded) {
      final currentState = state as NfrClientLoaded;
      if (currentState.clientData.data.clients.currentPage >= currentState.clientData.data.clients.total ~/ 20 + 1) {
        _isFetchingMore = false;
        return;
      }

      try {
        emit(NfrClientLoaded(currentState.clientData, isLoadingMore: true));
        final nextPageData = await apiService.getNfrClients(
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
        emit(NfrClientLoaded(updatedResponse, isLoadingMore: false));
      } catch (e) {
        emit(NfrClientError(e.toString()));
      } finally {
        _isFetchingMore = false;
      }
    }
  }

  Future<void> _onApplyNfrFilters(ApplyNfrFilters event, Emitter<NfrClientState> emit) async {
    _currentFilters = event.filters;
    add(FetchNfrClients());
  }

  Future<void> _onSearchNfrClients(SearchNfrClients event, Emitter<NfrClientState> emit) async {
    _currentSearchQuery = event.query;
    add(FetchNfrClients());
  }
}