import 'package:billing_mobile/models/clientsById_model.dart';
import 'package:billing_mobile/models/organizations_model.dart';

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
      id: json['id'],
      clientId: json['client_id'],
      tariffId: json['tariff_id'],
      saleId: json['sale_id'],
      sum: json['sum'],
      type: json['type'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      organizationId: json['organization_id'],
      tariff: json['tariff'] != null ? Tariff.fromJson(json['tariff']) : null,
      sale: json['sale'] != null ? Sale.fromJson(json['sale']) : null,
      organization: json['organization'] != null ? Organization.fromJson(json['organization']) : null,
    );
  }
}