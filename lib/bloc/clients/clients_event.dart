abstract class ClientEvent {}

class FetchClients extends ClientEvent {}

class FetchMoreClients extends ClientEvent {}

class CreateClients extends ClientEvent {
  final String fio;
  final String phone;
  final String email;
  final String? contactPerson;
  final String subDomain;
  final int? partnerid;
  final String clientType;
  final int? tarrifId;
  final int? saleId;
  final int? countryId;
  final bool isDemo;

  CreateClients({
    required this.fio,
    required this.phone,
    required this.email,
    this.contactPerson,
    required this.subDomain,
    this.partnerid,
    required this.clientType,
    this.tarrifId,
    this.saleId,
    this.countryId,
    required this.isDemo,
  });
}

class ApplyFilters extends ClientEvent {
  final Map<String, dynamic> filters;

  ApplyFilters(this.filters);
}

class SearchClients extends ClientEvent {
  final String query;

  SearchClients(this.query);
}