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
      currentPage: json['current_page'] ?? 1,
      data: (json['data'] as List?)?.map((e) => Client.fromJson(e)).toList() ??
          [],
      total: json['total'] ?? 0,
    );
  }
}

class Client {
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
    final currencyCode = clientJson['country']?['currency']?['symbol_code'];
    final rawBalance = json['balance'] ?? clientJson['balance'] ?? '0.00';
    final balance =
        currencyCode != null && rawBalance.toString().split(' ').length == 1
            ? '$rawBalance $currencyCode'
            : rawBalance.toString();

    return Client(
      id: clientJson['id'] ?? json['client_id'] ?? json['id'] ?? 0,
      name: clientJson['name'] ?? json['name'] ?? '',
      phone: clientJson['phone'] ?? json['phone'] ?? '',
      subDomain: clientJson['sub_domain'] ?? '',
      balance: balance,
      isActive: json['has_access'] != null
          ? json['has_access'] == 1
          : clientJson['is_active'] ?? false,
      isDemo: clientJson['is_demo'] ?? json['is_demo'] ?? false,
      email: clientJson['email'] ?? json['email'],
      clientType: clientJson['client_type'] ?? '',
      tariff: clientJson['tariff_price']?['tariff'] != null
          ? Tariff.fromJson(clientJson['tariff_price']['tariff'])
          : Tariff(
              id: 0,
              name: 'Unknown',
            ),
      nfr: clientJson['nfr'] ?? 0,
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
