import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/country/country_event.dart';
import 'package:billing_mobile/bloc/country/country_state.dart';
import 'package:bloc/bloc.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  final ApiService apiService;

  CountryBloc({required this.apiService}) : super(CountryInitialState()) {
    on<LoadCountryEvent>(_onLoadCountry);
  }

Future<void> _onLoadCountry( LoadCountryEvent event, Emitter<CountryState> emit ) async {
  emit(CountryLoadingState());
  try {
    final countries = await apiService.getCountries();
    if (countries.isEmpty) {
      // emit(CountryErrorState('No Countrys found'));
    } else {
      emit(CountryLoadedState(countries));
    }
  } catch (e) {
    emit(CountryErrorState('Failed to load Countrys: $e'));
  }
}

}