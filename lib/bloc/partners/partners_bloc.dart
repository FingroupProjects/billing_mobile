import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/partners/partners_event.dart';
import 'package:billing_mobile/bloc/partners/partners_state.dart';
import 'package:bloc/bloc.dart';

class PartnerBloc extends Bloc<PartnerEvent, PartnerState> {
  final ApiService apiService;

  PartnerBloc({required this.apiService}) : super(PartnerInitialState()) {
    on<LoadPartnerEvent>(_onLoadPartner);
  }

Future<void> _onLoadPartner(
  LoadPartnerEvent event,
  Emitter<PartnerState> emit,
) async {
  emit(PartnerLoadingState());
  
  try {
    final partners = await apiService.getPartners();
    if (partners.isEmpty) {
      // emit(PartnerErrorState('No Partners found'));
    } else {
      emit(PartnerLoadedState(partners));
    }
  } catch (e) {
    emit(PartnerErrorState('Failed to load Partners: $e'));
  }
}

}