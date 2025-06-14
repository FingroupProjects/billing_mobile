class Organization {
  final int id;
  final String name;
  final int? INN; // Made nullable to match server response
  final String phone;
  final String? address; // Already nullable
  final int hasAccess;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? businessTypeId; // Made nullable to match server response
  final String? rejectCause;
  final String businessTypeName;
  final double? balance; // Already nullable

  Organization({
    required this.id,
    required this.name,
    this.INN,
    required this.phone,
    this.address,
    required this.hasAccess,
    required this.createdAt,
    required this.updatedAt,
    this.businessTypeId,
    this.rejectCause,
    required this.businessTypeName,
    this.balance,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'] is int ? json['id'] : 0, // Ensure int type
      name: json['name']?.toString() ?? '', // Convert to string, default to ''
      INN: json['INN'] is int ? json['INN'] : null, // Handle null
      phone: json['phone']?.toString() ?? '', // Convert to string, default to ''
      address: json['address']?.toString(), // Nullable, convert to string
      hasAccess: json['has_access'] is int ? json['has_access'] : 0, // Ensure int type
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
      businessTypeId: json['business_type_id'] is int ? json['business_type_id'] : null, // Handle null
      rejectCause: json['reject_cause']?.toString(), // Nullable, convert to string
      businessTypeName: json['business_type'] != null && json['business_type']['name'] != null
          ? json['business_type']['name'].toString()
          : '',
      balance: json['balance'] != null
          ? double.tryParse(json['balance'].toString()) // Handle string or number
          : null,
    );
  }
}