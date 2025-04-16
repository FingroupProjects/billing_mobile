import 'package:billing_mobile/models/clientsById_model.dart';
import 'package:billing_mobile/models/organizations_model.dart';

class TransactionListResponse {
  final String view;
  final TransactionList data;

  TransactionListResponse({required this.view, required this.data});

  factory TransactionListResponse.fromJson(Map<String, dynamic> json) {
    return TransactionListResponse(
      view: json['view'] ?? '',
      data: TransactionList.fromJson(json['data'] ?? {}),
    );
  }
}

class TransactionList {
  final int currentPage;
  final int lastPage;
  final List<Transaction> data;
  final int total;

  TransactionList({
    this.currentPage = 1,
    this.lastPage = 1,
    this.data = const [],
    this.total = 0,
  });

  factory TransactionList.fromJson(Map<String, dynamic> json) {
    return TransactionList(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      data: (json['data'] as List?)?.map((e) => Transaction.fromJson(e)).toList() ?? [],
      total: json['total'] ?? 0,
    );
  }
}

class Transaction {
  final int id;
  final int clientId;
  final int? tariffId;
  final int? saleId;
  final String sum;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? organizationId;
  final Tariff? tariff;
  final Sale? sale;
  final Organization? organization;

  Transaction({
    required this.id,
    required this.clientId,
    this.tariffId,
    this.saleId,
    required this.sum,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.organizationId,
    this.tariff,
    this.sale,
    this.organization,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? 0,
      clientId: json['client_id'] ?? 0,
      tariffId: json['tariff_id'],
      saleId: json['sale_id'],
      sum: json['sum'] ?? '0.00',
      type: json['type'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toString()),
      organizationId: json['organization_id'],
      tariff: json['tariff'] != null ? Tariff.fromJson(json['tariff']) : null,
      sale: json['sale'] != null ? Sale.fromJson(json['sale']) : null,
      organization: json['organization'] != null ? Organization.fromJson(json['organization']) : null,
    );
  }
}