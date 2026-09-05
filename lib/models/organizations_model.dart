import 'dart:convert';

class Organization {
  final int id;
  final String orderNumber;
  final String name;
  final int? INN;
  final String phone;
  final String? address;
  final int hasAccess;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? businessTypeId;
  final String? rejectCause;
  final String businessTypeName;
  final double? balance;
  final bool isActive;
  final DateTime? calculatedValidUntil;

  Organization({
    required this.id,
    required this.orderNumber,
    required this.name,
    this.INN,
    required this.phone,
    this.address,
    required this.hasAccess,
    required this.createdAt,
    required this.updatedAt,
    this.businessTypeId,
    this.rejectCause,
    required this.businessTypeName,
    this.balance,
    required this.isActive,
    this.calculatedValidUntil,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: _parseInt(json['id']),
      orderNumber: json['order_number']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      INN: _tryParseInt(json['INN']),
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString(),
      hasAccess: _parseInt(json['has_access']),
      createdAt: _parseDateTime(json['created_at']) ?? DateTime.now(),
      updatedAt: _parseDateTime(json['updated_at']) ?? DateTime.now(),
      businessTypeId: _tryParseInt(json['business_type_id']),
      rejectCause: json['reject_cause']?.toString(),
      businessTypeName: json['business_type']?['name']?.toString() ?? '',
      balance: _tryParseDouble(json['real_balance'] ?? json['balance']),
      isActive: _parseOrganizationActiveStatus(json),
      calculatedValidUntil: _parseDateTime(json['calculated_valid_until']),
    );
  }
}

class OrganizationDetails {
  final Organization organization;
  final OrganizationClient client;
  final List<ConnectedService> connectedServices;
  final List<ConnectionStatusHistoryItem> connectionStatusHistory;
  final List<BalanceOperation> balanceOperations;
  final double realBalance;
  final List<IntegrationLog> integrationLogs;

  OrganizationDetails({
    required this.organization,
    required this.client,
    required this.connectedServices,
    required this.connectionStatusHistory,
    required this.balanceOperations,
    required this.realBalance,
    required this.integrationLogs,
  });

  factory OrganizationDetails.fromJson(Map<String, dynamic> json) {
    final organizationJson =
        json['organization'] as Map<String, dynamic>? ?? {};
    final clientJson =
        organizationJson['client'] as Map<String, dynamic>? ?? {};

    return OrganizationDetails(
      organization: Organization.fromJson({
        ...organizationJson,
        'real_balance':
            json['real_balance'] ?? organizationJson['real_balance'],
        'calculated_valid_until': json['calculated_valid_until'] ??
            organizationJson['calculated_valid_until'],
        'connection_status_history': json['connection_status_history'] ??
            organizationJson['connection_status_history'],
      }),
      client: OrganizationClient.fromJson(clientJson),
      connectedServices: (json['connected_services'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(ConnectedService.fromJson)
          .toList(),
      connectionStatusHistory:
          (json['connection_status_history'] as List? ?? [])
              .whereType<Map<String, dynamic>>()
              .map(ConnectionStatusHistoryItem.fromJson)
              .toList(),
      balanceOperations: (json['balance_operations'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(BalanceOperation.fromJson)
          .toList(),
      realBalance: _tryParseDouble(json['real_balance']) ?? 0,
      integrationLogs: (json['integration_logs'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(IntegrationLog.fromJson)
          .toList(),
    );
  }
}

class OrganizationClient {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String subDomain;
  final DateTime? lastActivity;
  final bool isActive;
  final bool isDemo;
  final String countryName;
  final String currencySymbolCode;
  final String partnerName;

  OrganizationClient({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.subDomain,
    required this.lastActivity,
    required this.isActive,
    required this.isDemo,
    required this.countryName,
    required this.currencySymbolCode,
    required this.partnerName,
  });

  factory OrganizationClient.fromJson(Map<String, dynamic> json) {
    return OrganizationClient(
      id: _parseInt(json['id']),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      subDomain: json['sub_domain']?.toString() ?? '',
      lastActivity: _parseDateTime(json['last_activity']),
      isActive: _parseBool(json['is_active']),
      isDemo: _parseBool(json['is_demo']),
      countryName: json['country']?['name']?.toString() ?? '',
      currencySymbolCode:
          json['country']?['currency']?['symbol_code']?.toString() ?? '',
      partnerName: json['partner']?['name']?.toString() ?? '',
    );
  }
}

class ConnectedService {
  final int id;
  final int quantity;
  final String tariffName;
  final String currencyCode;
  final double monthlyAmount;
  final bool isActive;
  final DateTime? connectedAt;
  final DateTime? deactivatedAt;

  ConnectedService({
    required this.id,
    required this.quantity,
    required this.tariffName,
    required this.currencyCode,
    required this.monthlyAmount,
    required this.isActive,
    required this.connectedAt,
    required this.deactivatedAt,
  });

  factory ConnectedService.fromJson(Map<String, dynamic> json) {
    return ConnectedService(
      id: _parseInt(json['id']),
      quantity: _parseInt(json['quantity'], fallback: 1),
      tariffName: json['tariff']?['name']?.toString() ?? 'Unknown',
      currencyCode: json['offer_currency']?['symbol_code']?.toString() ?? '',
      monthlyAmount: _tryParseDouble(json['service_total_amount']) ?? 0,
      isActive: _parseBool(json['status']),
      connectedAt: _parseDateTime(json['date']),
      deactivatedAt: _parseDateTime(json['deactivated_at']),
    );
  }
}

class ConnectionStatusHistoryItem {
  final int id;
  final String status;
  final DateTime? statusDate;
  final String authorName;
  final int? commercialOfferId;
  final String requestType;
  final String reason;

  ConnectionStatusHistoryItem({
    required this.id,
    required this.status,
    required this.statusDate,
    required this.authorName,
    required this.commercialOfferId,
    required this.requestType,
    required this.reason,
  });

  factory ConnectionStatusHistoryItem.fromJson(Map<String, dynamic> json) {
    return ConnectionStatusHistoryItem(
      id: _parseInt(json['id']),
      status: json['status']?.toString() ?? '',
      statusDate: _parseDateTime(json['status_date']),
      authorName: json['author']?['name']?.toString() ?? '',
      commercialOfferId: _tryParseInt(
          json['commercial_offer']?['id'] ?? json['commercial_offer_id']),
      requestType: json['commercial_offer']?['request_type']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
    );
  }
}

class BalanceOperation {
  final int id;
  final double amount;
  final String type;
  final String currencyCode;
  final DateTime? date;

  BalanceOperation({
    required this.id,
    required this.amount,
    required this.type,
    required this.currencyCode,
    required this.date,
  });

  factory BalanceOperation.fromJson(Map<String, dynamic> json) {
    return BalanceOperation(
      id: _parseInt(json['id']),
      amount: _tryParseDouble(json['sum']) ?? 0,
      type: json['type']?.toString() ?? '',
      currencyCode: json['currency']?['symbol_code']?.toString() ?? '',
      date: _parseDateTime(json['date']),
    );
  }
}

class IntegrationLog {
  final int id;
  final DateTime? date;
  final String type;
  final String action;
  final String target;
  final String status;
  final String details;

  IntegrationLog({
    required this.id,
    required this.date,
    required this.type,
    required this.action,
    required this.target,
    required this.status,
    required this.details,
  });

  factory IntegrationLog.fromJson(Map<String, dynamic> json) {
    return IntegrationLog(
      id: _parseInt(json['id']),
      date: _parseDateTime(
        json['date'] ??
            json['created_at'] ??
            json['sent_at'] ??
            json['updated_at'],
      ),
      type: _firstNonEmpty([
        json['type'],
        json['channel'],
        json['source'],
      ]),
      action: _firstNonEmpty([
        json['action'],
        json['event'],
        json['method'],
      ]),
      target: _firstNonEmpty([
        json['to'],
        json['target'],
        json['url'],
        json['endpoint'],
        json['email'],
      ]),
      status: _firstNonEmpty([
        json['status'],
        json['status_text'],
        json['response_status'],
      ]),
      details: _extractLogDetails(json),
    );
  }
}

bool _parseOrganizationActiveStatus(Map<String, dynamic> json) {
  final client = json['client'];
  if (client is Map && client.containsKey('is_active')) {
    return _parseBool(client['is_active']);
  }

  if (json.containsKey('is_active')) {
    return _parseBool(json['is_active']);
  }

  final history = json['connection_status_history'] as List?;
  if (history != null && history.isNotEmpty) {
    final normalizedHistory = history
        .whereType<Map>()
        .map((item) => item.cast<String, dynamic>())
        .toList();

    normalizedHistory.sort((a, b) {
      final aDate = _parseDateTime(a['status_date']);
      final bDate = _parseDateTime(b['status_date']);
      if (aDate != null && bDate != null) {
        final dateCompare = bDate.compareTo(aDate);
        if (dateCompare != 0) return dateCompare;
      }
      if (aDate == null) return 1;
      if (bDate == null) return -1;

      return _parseInt(b['id']).compareTo(_parseInt(a['id']));
    });

    final latestStatus =
        normalizedHistory.first['status']?.toString().toLowerCase();
    if (latestStatus == 'connected') return true;
    if (latestStatus == 'disconnected') return false;
  }

  return _parseBool(json['has_access']);
}

String _extractLogDetails(Map<String, dynamic> json) {
  final directDetails = _firstNonEmpty([
    json['details'],
    json['message'],
    json['body'],
    json['response_body'],
    json['description'],
  ]);
  if (directDetails.isNotEmpty) {
    return directDetails;
  }

  final filtered = Map<String, dynamic>.from(json)
    ..removeWhere((key, value) => [
          'id',
          'date',
          'created_at',
          'updated_at',
          'sent_at',
          'type',
          'channel',
          'source',
          'action',
          'event',
          'method',
          'to',
          'target',
          'url',
          'endpoint',
          'email',
          'status',
          'status_text',
          'response_status',
        ].contains(key));

  return filtered.isEmpty ? '' : jsonEncode(filtered);
}

String _firstNonEmpty(List<dynamic> values) {
  for (final value in values) {
    final text = value?.toString() ?? '';
    if (text.isNotEmpty && text != 'null') {
      return text;
    }
  }
  return '';
}

int _parseInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

int? _tryParseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

double? _tryParseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString());
}

bool _parseBool(dynamic value) {
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) {
    final normalizedValue = value.toLowerCase();
    return normalizedValue == 'true' || normalizedValue == '1';
  }
  return false;
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
