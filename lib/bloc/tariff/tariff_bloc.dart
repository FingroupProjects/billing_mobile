import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/tariff/tariff_event.dart';
import 'package:billing_mobile/bloc/tariff/tariff_state.dart';
import 'package:bloc/bloc.dart';

class TariffBloc extends Bloc<TariffEvent, TariffState> {
  final ApiService apiService;

  TariffBloc({required this.apiService}) : super(TariffInitialState()) {
    on<LoadTariffEvent>(_onLoadTariff);
    on<ResetTariffEvent>(_onResetTariff); // Added handler for ResetTariffEvent
  }

  Future<void> _onLoadTariff(LoadTariffEvent event, Emitter<TariffState> emit) async {
    emit(TariffLoadingState());
    try {
      final tariffs = await apiService.getTariffs(event.code); // Pass code to getTariffs
      if (tariffs.isEmpty) {
        emit(TariffErrorState('No tariffs found for code ${event.code}'));
      } else {
        emit(TariffLoadedState(tariffs));
      }
    } catch (e) {
      emit(TariffErrorState('Failed to load tariffs: $e'));
    }
  }

  Future<void> _onResetTariff(ResetTariffEvent event, Emitter<TariffState> emit) async {
    emit(TariffInitialState()); // Reset state
  }
}