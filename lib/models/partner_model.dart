class Partner {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;

  Partner({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
    );
  }
}