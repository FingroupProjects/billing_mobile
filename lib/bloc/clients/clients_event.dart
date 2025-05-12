abstract class ClientEvent {}

class FetchClients extends ClientEvent {}

class FetchMoreClients extends ClientEvent {}

class CreateClients extends ClientEvent {
  final String fio;
  final String phone;
  final String email;
  final int? tarrifId;
  final bool isDemo;

  CreateClients({
    required this.fio,
    required this.phone,
    required this.email,
    this.tarrifId,
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