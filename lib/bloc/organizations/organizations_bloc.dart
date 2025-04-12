// bloc/organization_bloc.dart
import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/organizations/organizations_event.dart';
import 'package:billing_mobile/bloc/organizations/organizations_state.dart';
import 'package:bloc/bloc.dart';

class OrganizationBloc extends Bloc<OrganizationEvent, OrganizationState> {
  final ApiService apiService;

  OrganizationBloc({required this.apiService}) : super(OrganizationInitialState()) {
    on<LoadOrganizationEvent>(_onLoadOrganization);
    on<ResetOrganizationEvent>(_onResetOrganization);
  }

Future<void> _onLoadOrganization(
  LoadOrganizationEvent event,
  Emitter<OrganizationState> emit,
) async {
  emit(OrganizationLoadingState());
  
  try {
    final organizations = await apiService.getClientByIdOrganizations(event.clientId);
    if (organizations.isEmpty) {
      // emit(OrganizationErrorState('No organizations found'));
    } else {
      emit(OrganizationLoadedState(organizations));
    }
  } catch (e) {
    emit(OrganizationErrorState('Failed to load organizations: $e'));
  }
}

  void _onResetOrganization(
    ResetOrganizationEvent event,
    Emitter<OrganizationState> emit,
  ) {
    emit(OrganizationInitialState());
  }
}