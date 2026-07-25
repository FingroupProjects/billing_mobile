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
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      // The partners endpoint may return a null address.
      address: json['address']?.toString() ?? '',
    );
  }
}
