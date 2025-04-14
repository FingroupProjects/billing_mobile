class SaleData {
  final int id;
  final String name;
  final String saleType;
  final String amount;
  final int active;
  final DateTime createdAt;
  final DateTime updatedAt;

  SaleData({
    required this.id,
    required this.name,
    required this.saleType,
    required this.amount,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SaleData.fromJson(Map<String, dynamic> json) {
    return SaleData(
      id: json['id'],
      name: json['name'],
      saleType: json['sale_type'],
      amount: json['amount'],
      active: json['active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}