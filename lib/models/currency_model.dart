class CurrencyData {
  final int id;
  final String name;
  // final String code; // Assuming currencies have a code (e.g., USD, EUR)

  CurrencyData({
    required this.id,
    required this.name,
    // required this.code,
  });

  factory CurrencyData.fromJson(Map<String, dynamic> json) {
    return CurrencyData(
      id: json['id'],
      name: json['name'],
      // code: json['code'],
    );
  }
}