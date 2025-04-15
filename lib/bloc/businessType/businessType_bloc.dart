import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/businessType/businessType_event.dart';
import 'package:billing_mobile/bloc/businessType/businessType_state.dart';
import 'package:bloc/bloc.dart';

class BusinessTypeBloc extends Bloc<BusinessTypeEvent, BusinessTypeState> {
  final ApiService apiService;

  BusinessTypeBloc({required this.apiService}) : super(BusinessTypeInitialState()) {
    on<LoadBusinessTypeEvent>(_onLoadBusinessType);
  }

Future<void> _onLoadBusinessType(
  LoadBusinessTypeEvent event,
  Emitter<BusinessTypeState> emit,
) async {
  emit(BusinessTypeLoadingState());
  
  try {
    final businessTypes = await apiService.getBusinessType();
    if (businessTypes.isEmpty) {
      // emit(BusinessTypeErrorState('No BusinessTypes found'));
    } else {
      emit(BusinessTypeLoadedState(businessTypes));
    }
  } catch (e) {
    emit(BusinessTypeErrorState('Failed to load BusinessTypes: $e'));
  }
}

}