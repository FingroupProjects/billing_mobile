
import 'package:billing_mobile/models/clientsById_model.dart';

abstract class ClientByIdState {}

class ClientByIdInitial extends ClientByIdState {}

class ClientByIdLoading extends ClientByIdState {}

class ClientByIdLoaded extends ClientByIdState {
  final ClientById client;
  final List<BusinessType> businessTypes;
  final List<Sale> sales;
  final List<Tariff> tariffs;
  final List<Pack> packs;

  ClientByIdLoaded({
    required this.client,
    required this.businessTypes,
    required this.sales,
    required this.tariffs,
    required this.packs,
  });
}

class ClientByIdError extends ClientByIdState {
  final String message;
  ClientByIdError(this.message);
}