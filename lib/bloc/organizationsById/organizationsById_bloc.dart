import 'dart:io';

import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/organizationsById/organizationsById_event.dart';
import 'package:billing_mobile/bloc/organizationsById/organizationsById_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrganizationByIdBloc
    extends Bloc<OrganizationByIdEvent, OrganizationByIdState> {
  final ApiService apiService;

  OrganizationByIdBloc({required this.apiService})
      : super(const OrganizationByIdInitialState()) {
    on<FetchOrganizationByIdEvent>(_fetchOrganizationById);
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  Future<void> _fetchOrganizationById(
    FetchOrganizationByIdEvent event,
    Emitter<OrganizationByIdState> emit,
  ) async {
    emit(const OrganizationByIdLoading());

    final hasConnection = await _checkInternetConnection();
    if (!hasConnection) {
      emit(const OrganizationByIdError('Нет интернет соединения!'));
      return;
    }

    try {
      final organizationDetails =
          await apiService.getOrganizationsById(event.organizationId);
      emit(OrganizationByIdLoaded(organizationDetails));
    } catch (e) {
      emit(const OrganizationByIdError('Failed to load organizationsByID: '));
    }
  }
}
