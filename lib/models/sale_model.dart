class SaleData {
  final int id;
  final String name;
  final String saleType;
  final String amount;
  final int active;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SaleData({
    required this.id,
    required this.name,
    required this.saleType,
    required this.amount,
    required this.active,
    this.createdAt,
    this.updatedAt,
  });

  factory SaleData.fromJson(Map<String, dynamic> json) {
    return SaleData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      saleType: json['sale_type'] ?? '',
      amount: json['amount']?.toString() ?? '0',
      active: json['active'] ?? 0,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }
}