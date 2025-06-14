import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/currency/currency_event.dart';
import 'package:billing_mobile/bloc/currency/currency_state.dart';
import 'package:bloc/bloc.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final ApiService apiService;

  CurrencyBloc({required this.apiService}) : super(CurrencyInitialState()) {
    on<LoadCurrencyEvent>(_onLoadCurrency);
  }

  Future<void> _onLoadCurrency(LoadCurrencyEvent event, Emitter<CurrencyState> emit) async {
    emit(CurrencyLoadingState());
    try {
      final currencies = await apiService.getCurrencies();
      if (currencies.isEmpty) {
        emit(CurrencyErrorState('No currencies found'));
      } else {
        emit(CurrencyLoadedState(currencies));
      }
    } catch (e) {
      emit(CurrencyErrorState('Failed to load currencies: $e'));
    }
  }
}