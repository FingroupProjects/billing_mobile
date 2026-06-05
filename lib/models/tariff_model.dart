class Tariff {
  final int id;
  final String name;
  final double price;
  final int userCount;
  final int projectCount;
  final String createdAt;
  final String updatedAt;

  Tariff({
    required this.id,
    required this.name,
    required this.price,
    required this.userCount,
    required this.projectCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tariff.fromJson(Map<String, dynamic> json) {
    return Tariff(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      price: _parseDouble(json['price']),
      userCount: _parseInt(json['user_count']),
      projectCount: _parseInt(json['project_count']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is num) return value.toInt();
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static String _parseString(dynamic value) {
    return value?.toString() ?? '';
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
  final Tariff tariff;

  TariffData({
    required this.id,
    required this.currencyId,
    required this.tariffId,
    required this.tariffPrice,
    required this.licensePrice,
    this.createdAt,
    this.updatedAt,
    required this.tariff,
  });

  factory TariffData.fromJson(Map<String, dynamic> json) {
    return TariffData(
      id: _parseInt(json['id']),
      currencyId: _parseInt(json['currency_id']),
      tariffId: _parseInt(json['tariff_id']),
      tariffPrice: _parseDouble(json['tariff_price']),
      licensePrice: _parseDouble(json['license_price']),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      tariff: Tariff.fromJson(
        (json['tariff'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is num) return value.toInt();
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
