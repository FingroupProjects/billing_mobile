
class History {
  final int id;
  final int userId;
  final String status;
  final int modelId;
  final String modelType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<HistoryChange> changes;
  final HistoryUser user;

  History({
    required this.id,
    required this.userId,
    required this.status,
    required this.modelId,
    required this.modelType,
    required this.createdAt,
    required this.updatedAt,
    required this.changes,
    required this.user,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'],
      userId: json['user_id'],
      status: json['status'],
      modelId: json['model_id'],
      modelType: json['model_type'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      changes: (json['changes'] as List)
          .map((e) => HistoryChange.fromJson(e))
          .toList(),
      user: HistoryUser.fromJson(json['user']),
    );
  }
}

class HistoryChange {
  final int id;
  final int modelHistoryId;
  final String body;
  final DateTime createdAt;
  final DateTime updatedAt;

  HistoryChange({
    required this.id,
    required this.modelHistoryId,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HistoryChange.fromJson(Map<String, dynamic> json) {
    return HistoryChange(
      id: json['id'],
      modelHistoryId: json['model_history_id'],
      body: json['body'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class HistoryUser {
  final int id;
  final String name;
  final String login;
  final String email;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? phone;
  final String? address;
  final String role;
  final int? partnerStatusId;

  HistoryUser({
    required this.id,
    required this.name,
    required this.login,
    required this.email,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    this.phone,
    this.address,
    required this.role,
    this.partnerStatusId,
  });

  factory HistoryUser.fromJson(Map<String, dynamic> json) {
    return HistoryUser(
      id: json['id'],
      name: json['name'],
      login: json['login'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'] != null 
          ? DateTime.parse(json['email_verified_at']) 
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      phone: json['phone'],
      address: json['address'],
      role: json['role'],
      partnerStatusId: json['partner_status_id'],
    );
  }
}