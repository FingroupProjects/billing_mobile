class Organization {
  final int id;
  final String name;
  final int INN;
  final String phone;
  final String address;
  final int clientId;
  final int hasAccess;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int businessTypeId;
  final String? rejectCause;

  Organization({
    required this.id,
    required this.name,
    required this.INN,
    required this.phone,
    required this.address,
    required this.clientId,
    required this.hasAccess,
    required this.createdAt,
    required this.updatedAt,
    required this.businessTypeId,
    this.rejectCause,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      INN: json['INN'] ?? 0,
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      clientId: json['client_id'] ?? 0,
      hasAccess: json['has_access'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toString()),
      businessTypeId: json['business_type_id'] ?? 0,
      rejectCause: json['reject_cause'],
    );
  }
}