import 'dart:io';

import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/organizations/organizations_event.dart';
import 'package:billing_mobile/bloc/organizations/organizations_state.dart';
import 'package:bloc/bloc.dart';

class OrganizationBloc extends Bloc<OrganizationEvent, OrganizationState> {
  final ApiService apiService;

  OrganizationBloc({required this.apiService}) : super(OrganizationInitialState()) {
    on<FetchOrganizationEvent>(_fetchOrganization);
    on<ResetOrganizationEvent>(_onResetOrganization);
    on<CreateOrganizations>(_createOrganizations);
  }


  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }
  
Future<void> _fetchOrganization( FetchOrganizationEvent event, Emitter<OrganizationState> emit ) async { emit(OrganizationLoading());
  try {
    final organizations = await apiService.getClientByIdOrganizations(event.clientId);
    if (organizations.isEmpty) {
      // emit(OrganizationError('No organizations found'));
    } else {
      emit(OrganizationLoaded(organizations));
    }
  } catch (e) {
    emit(OrganizationError('Failed to load organizations: $e'));
  }
}

  void _onResetOrganization(
    ResetOrganizationEvent event,
    Emitter<OrganizationState> emit,
  ) {
    emit(OrganizationInitialState());
  }

 Future<void> _createOrganizations(CreateOrganizations event, Emitter<OrganizationState> emit) async {
    emit(OrganizationLoading());

    if (await _checkInternetConnection()) {
      try {
        final result = await apiService.createOrganizations(
          clientId: event.clientId,
          name: event.name,
          phone: event.phone,
          inn: event.inn,
          businessTypeId: event.businessTypeId,
          address: event.address,
        );

        if (result['success']) {
          emit(OrganizationCreated('Организация успешно создана!'));
        } else {
          emit(OrganizationCreateError(result['message'] ?? 'Ошибка при создании организации'));
        }
      } catch (e) {
        emit(OrganizationCreateError('Ошибка создания организации: $e'));
      }
    } else {
      emit(OrganizationCreateError('Нет подключения к интернету'));
    }
  }
}