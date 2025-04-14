class CountryData {
  final int id;
  final String name;

  CountryData({
    required this.id,
    required this.name,

  });

  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(
      id: json['id'],
      name: json['name'],
      
    );
  }
}