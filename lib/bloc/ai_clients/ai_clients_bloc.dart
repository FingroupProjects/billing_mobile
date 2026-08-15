import 'dart:io';

import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/ai_clients/ai_clients_event.dart';
import 'package:billing_mobile/bloc/ai_clients/ai_clients_state.dart';
import 'package:billing_mobile/models/ai_subscription_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiClientsBloc extends Bloc<AiClientsEvent, AiClientsState> {
  final ApiService apiService;
  int _currentPage = 1;
  bool _isFetchingMore = false;
  String _currentSearchQuery = '';

  AiClientsBloc({required this.apiService}) : super(AiClientsInitial()) {
    on<FetchAiClients>(_onFetchAiClients);
    on<FetchMoreAiClients>(_onFetchMoreAiClients);
    on<SearchAiClients>(_onSearchAiClients);
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  Future<void> _onFetchAiClients(
    FetchAiClients event,
    Emitter<AiClientsState> emit,
  ) async {
    emit(AiClientsLoading());
    if (!await _checkInternetConnection()) {
      emit(AiClientsError('Нет подключения к интернету'));
      return;
    }

    try {
      _currentPage = 1;
      final subscriptions = await apiService.getAiSubscriptions(
        page: _currentPage,
        search: _currentSearchQuery,
      );
      emit(AiClientsLoaded(subscriptions));
    } catch (_) {
      emit(AiClientsError('Ошибка загрузки ИИ-клиентов!'));
    }
  }

  Future<void> _onFetchMoreAiClients(
    FetchMoreAiClients event,
    Emitter<AiClientsState> emit,
  ) async {
    if (_isFetchingMore || state is! AiClientsLoaded) return;
    _isFetchingMore = true;

    final currentState = state as AiClientsLoaded;
    if (currentState.subscriptions.data.length >=
        currentState.subscriptions.total) {
      _isFetchingMore = false;
      return;
    }

    try {
      emit(AiClientsLoaded(
        currentState.subscriptions,
        isLoadingMore: true,
      ));
      final nextPageData = await apiService.getAiSubscriptions(
        page: _currentPage + 1,
        search: _currentSearchQuery,
      );

      final updated = AiSubscriptionListResponse(
        currentPage: nextPageData.currentPage,
        data: [...currentState.subscriptions.data, ...nextPageData.data],
        total: nextPageData.total,
        lastPage: nextPageData.lastPage,
      );

      _currentPage++;
      emit(AiClientsLoaded(updated));
    } catch (_) {
      emit(AiClientsError('Ошибка загрузки ИИ-клиентов!'));
    } finally {
      _isFetchingMore = false;
    }
  }

  Future<void> _onSearchAiClients(
    SearchAiClients event,
    Emitter<AiClientsState> emit,
  ) async {
    _currentSearchQuery = event.query;
    add(FetchAiClients());
  }
}
