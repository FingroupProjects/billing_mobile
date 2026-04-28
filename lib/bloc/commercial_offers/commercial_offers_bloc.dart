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

  CommercialOffersBloc({required this.apiService})
      : super(CommercialOffersInitial()) {
    on<FetchCommercialOffers>(_onFetchCommercialOffers);
    on<FetchMoreCommercialOffers>(_onFetchMoreCommercialOffers);
    on<SearchCommercialOffers>(_onSearchCommercialOffers);
    on<FetchCommercialOfferStatuses>(_onFetchCommercialOfferStatuses);
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
      final offers = await apiService.getCommercialOffers(
        page: _currentPage,
        search: _currentSearchQuery,
      );
      emit(CommercialOffersLoaded(offers));
    } catch (e) {
      emit(CommercialOffersError(e.toString()));
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
      final nextPageData = await apiService.getCommercialOffers(
        page: _currentPage + 1,
        search: _currentSearchQuery,
      );

      final updatedOffers = CommercialOfferListResponse(
        currentPage: nextPageData.currentPage,
        data: [...currentState.offers.data, ...nextPageData.data],
        total: nextPageData.total,
        lastPage: nextPageData.lastPage,
      );

      _currentPage++;
      emit(CommercialOffersLoaded(updatedOffers));
    } catch (e) {
      emit(CommercialOffersError(e.toString()));
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
    } catch (e) {
      emit(CommercialOffersError(e.toString()));
    }
  }
}
