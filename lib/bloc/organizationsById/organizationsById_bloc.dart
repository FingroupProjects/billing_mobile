import 'dart:io';
import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/organizationsById/organizationsById_event.dart';
import 'package:billing_mobile/bloc/organizationsById/organizationsById_state.dart';
import 'package:bloc/bloc.dart';

class OrganizationByIdBloc extends Bloc<OrganizationByIdEvent, OrganizationByIdState> {
  final ApiService apiService;

  OrganizationByIdBloc({required this.apiService}) : super(OrganizationByIdInitialState()) {
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

Future<void> _fetchOrganizationById( FetchOrganizationByIdEvent event, Emitter<OrganizationByIdState> emit ) async { emit(OrganizationByIdLoading());
  try {
    final organizations = await apiService.getOrganizationsById(event.clientId);
    if (organizations.isEmpty) {
      // emit(OrganizationError('No organizations found'));
    } else {
      emit(OrganizationByIdLoaded(organizations));
    }
  } catch (e) {
    emit(OrganizationByIdError('Failed to load organizationsByID: $e'));
  }
}
}