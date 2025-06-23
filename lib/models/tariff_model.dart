class Tariff {
  final int id;
  final String name;
  final double price;
  final int userCount;
  final int projectCount;
  final String? createdAt;
  final String? updatedAt;

  Tariff({
    required this.id,
    required this.name,
    required this.price,
    required this.userCount,
    required this.projectCount,
   this.createdAt,
     this.updatedAt,
  });

  factory Tariff.fromJson(Map<String, dynamic> json) {
    return Tariff(
      id: _parseInt(json['id']),
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      userCount: _parseInt(json['user_count']),
      projectCount: _parseInt(json['project_count']),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    throw FormatException('Cannot parse $value to int');
  }
}

class TariffData {
  final int id;
  final int currencyId;
  final int tariffId;
  final double tariffPrice;
  final double licensePrice;
  final String? createdAt;
  final String? updatedAt;
  final Tariff? tariff;

  TariffData({
    required this.id,
    required this.currencyId,
    required this.tariffId,
    required this.tariffPrice,
    required this.licensePrice,
    this.createdAt,
    this.updatedAt,
    this.tariff,
  });

  factory TariffData.fromJson(Map<String, dynamic> json) {
    return TariffData(
      id: _parseInt(json['id']),
      currencyId: _parseInt(json['currency_id']),
      tariffId: _parseInt(json['tariff_id']),
      tariffPrice: (json['tariff_price'] as num).toDouble(),
      licensePrice: (json['license_price'] as num).toDouble(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      tariff: Tariff?.fromJson(json['tariff'] as Map<String, dynamic>),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    throw FormatException('Cannot parse $value to int');
  }
}