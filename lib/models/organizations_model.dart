int parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

class Organization {
  final int id;
  final String name;
  final int INN;
  final String phone;
  final String address;
  final int hasAccess;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int businessTypeId;
  final String? rejectCause;
  final String businessTypeName;

  Organization({
    required this.id,
    required this.name,
    required this.INN,
    required this.phone,
    required this.address,
    required this.hasAccess,
    required this.createdAt,
    required this.updatedAt,
    required this.businessTypeId,
    this.rejectCause,
    required this.businessTypeName,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: parseInt(json['id']),
      name: json['name'] ?? '',
      INN: parseInt(json['INN']),
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      hasAccess: parseInt(json['has_access']),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toString()),
      businessTypeId: parseInt(json['business_type_id']),
      rejectCause: json['reject_cause'],
      businessTypeName: json['business_type'] != null 
          ? json['business_type']['name'] ?? '' 
          : '',
    );
  }
}
