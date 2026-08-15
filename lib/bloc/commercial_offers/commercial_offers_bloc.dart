import 'dart:io';

import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/commercial_offers/commercial_offers_event.dart';
import 'package:billing_mobile/bloc/commercial_offers/commercial_offers_state.dart';
import 'package:billing_mobile/models/commercial_offer_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommercialOffersBloc
    extends Bloc<CommercialOffersEvent, CommercialOffersState> {
  final ApiService apiService;
  int _currentPage = 1;
  bool _isFetchingMore = false;
  String _currentSearchQuery = '';
  Map<String, dynamic> _currentFilters = {};

  CommercialOffersBloc({required this.apiService})
      : super(CommercialOffersInitial()) {
    on<FetchCommercialOffers>(_onFetchCommercialOffers);
    on<FetchMoreCommercialOffers>(_onFetchMoreCommercialOffers);
    on<SearchCommercialOffers>(_onSearchCommercialOffers);
    on<ApplyCommercialOfferFilters>(_onApplyCommercialOfferFilters);
    on<FetchCommercialOfferStatuses>(_onFetchCommercialOfferStatuses);
  }

  Future<CommercialOfferListResponse> _fetchOffers({required int page}) {
    return apiService.getCommercialOffers(
      page: page,
      search: _currentSearchQuery,
      partnerId: _readInt('partner_id'),
      requestType: _readString('request_type'),
      tariffId: _readInt('tariff_id'),
      periodMonths: _readInt('period_months'),
      operationStatus: _readString('operation_status'),
      dateFrom: _readString('date_from'),
      dateTo: _readString('date_to'),
    );
  }

  int? _readInt(String key) {
    final value = _currentFilters[key];
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString().trim());
  }

  String? _readString(String key) {
    final value = _currentFilters[key];
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty || text == 'null') return null;
    return text;
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  Future<void> _onFetchCommercialOffers(
    FetchCommercialOffers event,
    Emitter<CommercialOffersState> emit,
  ) async {
    emit(CommercialOffersLoading());
    if (!await _checkInternetConnection()) {
      emit(CommercialOffersError('Нет подключения к интернету'));
      return;
    }

    try {
      _currentPage = 1;
      final offers = await _fetchOffers(page: _currentPage);
      emit(CommercialOffersLoaded(offers));
    } catch (_) {
      emit(CommercialOffersError('Ошибка загрузки подключений!'));
    }
  }

  Future<void> _onFetchMoreCommercialOffers(
    FetchMoreCommercialOffers event,
    Emitter<CommercialOffersState> emit,
  ) async {
    if (_isFetchingMore || state is! CommercialOffersLoaded) return;
    _isFetchingMore = true;

    final currentState = state as CommercialOffersLoaded;
    if (currentState.offers.data.length >= currentState.offers.total) {
      _isFetchingMore = false;
      return;
    }

    try {
      emit(CommercialOffersLoaded(
        currentState.offers,
        isLoadingMore: true,
      ));
      final nextPageData = await _fetchOffers(page: _currentPage + 1);

      final updatedOffers = CommercialOfferListResponse(
        currentPage: nextPageData.currentPage,
        data: [...currentState.offers.data, ...nextPageData.data],
        total: nextPageData.total,
        lastPage: nextPageData.lastPage,
      );

      _currentPage++;
      emit(CommercialOffersLoaded(updatedOffers));
    } catch (_) {
      emit(CommercialOffersError('Ошибка загрузки подключений!'));
    } finally {
      _isFetchingMore = false;
    }
  }

  Future<void> _onSearchCommercialOffers(
    SearchCommercialOffers event,
    Emitter<CommercialOffersState> emit,
  ) async {
    _currentSearchQuery = event.query;
    add(FetchCommercialOffers());
  }

  Future<void> _onApplyCommercialOfferFilters(
    ApplyCommercialOfferFilters event,
    Emitter<CommercialOffersState> emit,
  ) async {
    _currentFilters = Map<String, dynamic>.from(event.filters);
    add(FetchCommercialOffers());
  }

  Future<void> _onFetchCommercialOfferStatuses(
    FetchCommercialOfferStatuses event,
    Emitter<CommercialOffersState> emit,
  ) async {
    emit(CommercialOfferStatusesLoading());
    if (!await _checkInternetConnection()) {
      emit(CommercialOffersError('Нет подключения к интернету'));
      return;
    }

    try {
      final statuses =
          await apiService.getCommercialOfferStatuses(event.offerId);
      emit(CommercialOfferStatusesLoaded(statuses));
    } catch (_) {
      emit(CommercialOffersError('Ошибка загрузки статусов подключения!'));
    }
  }
}
