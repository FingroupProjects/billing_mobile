class ClientListResponse {
  final String view;
  final ClientData data;

  ClientListResponse({required this.view, required this.data});

  factory ClientListResponse.fromJson(Map<String, dynamic> json) {
    return ClientListResponse(
      view: json['view'] ?? '',
      data: ClientData.fromJson(json['data'] ?? {}),
    );
  }
}

class ClientData {
  final ClientList clients;
  final List<Tariff> tariffs;

  ClientData({
    required this.clients,
    this.tariffs = const [],
  });

  factory ClientData.fromJson(Map<String, dynamic> json) {
    return ClientData(
      clients: ClientList.fromJson(json['clients'] ?? {}),
      tariffs:
          (json['tariffs'] as List?)?.map((e) => Tariff.fromJson(e)).toList() ??
              [],
    );
  }
}

class ClientList {
  final int currentPage;
  final List<Client> data;
  final int total;

  ClientList({
    this.currentPage = 1,
    this.data = const [],
    this.total = 0,
  });

  factory ClientList.fromJson(Map<String, dynamic> json) {
    return ClientList(
      currentPage: _parseInt(json['current_page'], fallback: 1),
      data: (json['data'] as List?)?.map((e) => Client.fromJson(e)).toList() ??
          [],
      total: _parseInt(json['total']),
    );
  }
}

int _parseInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

bool _parseBool(dynamic value, {bool fallback = false}) {
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) {
    final normalizedValue = value.toLowerCase();
    if (normalizedValue == 'true' || normalizedValue == '1') return true;
    if (normalizedValue == 'false' || normalizedValue == '0') return false;
  }
  return fallback;
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}

class Client {
  final int organizationId;
  final int id;
  final String name;
  final String phone;
  final String subDomain;
  final String balance;
  final bool isActive;
  final bool isDemo;
  final String? email;
  final String clientType;
  final DateTime? lastActivity;
  final Tariff tariff;
  final int nfr;

  Client({
    required this.organizationId,
    required this.id,
    required this.name,
    required this.phone,
    required this.subDomain,
    required this.balance,
    required this.isActive,
    required this.isDemo,
    this.email,
    this.clientType = '',
    this.lastActivity,
    required this.tariff,
    required this.nfr,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    final clientJson = json['client'] is Map<String, dynamic>
        ? json['client'] as Map<String, dynamic>
        : json;
    final organizationJson = json;
    final currencyCode = clientJson['country']?['currency']?['symbol_code'];
    final rawBalance = organizationJson['real_balance'] ??
        organizationJson['balance'] ??
        clientJson['real_balance'] ??
        clientJson['balance'] ??
        '0.00';
    final balance =
        currencyCode != null && rawBalance.toString().split(' ').length == 1
            ? '$rawBalance $currencyCode'
            : rawBalance.toString();

    return Client(
      organizationId: _parseInt(organizationJson['id']),
      id: _parseInt(
          clientJson['id'] ?? organizationJson['client_id'] ?? organizationJson['id']),
      name: (clientJson['name'] ?? organizationJson['name'] ?? '').toString(),
      phone: (clientJson['phone'] ?? organizationJson['phone'] ?? '').toString(),
      subDomain: (clientJson['sub_domain'] ?? '').toString(),
      balance: balance,
      isActive: organizationJson['has_access'] != null
          ? _parseBool(organizationJson['has_access'])
          : _parseBool(clientJson['is_active']),
      isDemo: _parseBool(clientJson['is_demo'] ?? organizationJson['is_demo']),
      email: (clientJson['email'] ?? organizationJson['email'])?.toString(),
      clientType: (clientJson['client_type'] ?? '').toString(),
      lastActivity: _parseDateTime(clientJson['last_activity']),
      tariff: clientJson['tariff_price']?['tariff'] != null
          ? Tariff.fromJson(clientJson['tariff_price']['tariff'])
          : Tariff(
              id: 0,
              name: 'Unknown',
            ),
      nfr: _parseInt(clientJson['nfr']),
    );
  }
}

class Tariff {
  final int id;
  final String name;

  Tariff({
    required this.id,
    required this.name,
  });

  factory Tariff.fromJson(Map<String, dynamic> json) {
    return Tariff(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
    );
  }
}
