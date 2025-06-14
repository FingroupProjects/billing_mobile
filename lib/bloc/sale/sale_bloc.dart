import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/sale/sale_event.dart';
import 'package:billing_mobile/bloc/sale/sale_state.dart';
import 'package:bloc/bloc.dart';

class SaleBloc extends Bloc<SaleEvent, SaleState> {
  final ApiService apiService;

  SaleBloc({required this.apiService}) : super(SaleInitialState()) {
    on<LoadSaleEvent>(_onLoadSale);
  }

  Future<void> _onLoadSale(LoadSaleEvent event, Emitter<SaleState> emit) async {
    emit(SaleLoadingState());
    try {
      final sales = await apiService.getSales();
      emit(SaleLoadedState(sales));
    } catch (e) {
      emit(SaleErrorState('Не удалось загрузить скидки: '));
    }
  }
}