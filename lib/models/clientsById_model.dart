// clientsById_model.dart
class ClientByIdResponse {
  final List<BusinessType> businessTypes;
  final List<Sale> sales;
  final List<Tariff> tariffs;
  final List<Pack> packs;
  final ClientById client;

  ClientByIdResponse({
    required this.businessTypes,
    required this.sales,
    required this.tariffs,
    required this.packs,
    required this.client,
  });

  factory ClientByIdResponse.fromJson(Map<String, dynamic> json) {
    return ClientByIdResponse(
      businessTypes: (json['businessTypes'] as List)
          .map((e) => BusinessType.fromJson(e))
          .toList(),
      sales: (json['sales'] as List).map((e) => Sale.fromJson(e)).toList(),
      tariffs: (json['tariffs'] as List).map((e) => Tariff.fromJson(e)).toList(),
      packs: (json['packs'] as List).map((e) => Pack.fromJson(e)).toList(),
      client: ClientById.fromJson(json['client']),
    );
  }
}

class ClientById {
  final int id;
  final String name;
  final String phone;
  final String subDomain;
  final int tariffId;
  final int? saleId;
  final String balance;
  final bool isActive;
  final bool isDemo;
  final String? email;
  final String clientType;
  final String? contactPerson;
  final int? partnerId;
  final int nfr;
  final String? rejectCause;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastActivity;
  final Tariff tariff;
  final BusinessType? businessType;
  final Sale? sale;
  final List<HistoryEntry> history;

  ClientById({
    required this.id,
    required this.name,
    required this.phone,
    required this.subDomain,
    required this.tariffId,
    this.saleId,
    required this.balance,
    required this.isActive,
    required this.isDemo,
    this.email,
    required this.clientType,
    this.contactPerson,
    this.partnerId,
    required this.nfr,
    this.rejectCause,
    required this.createdAt,
    required this.updatedAt,
    this.lastActivity,
    required this.tariff,
    this.businessType,
    this.sale,
    required this.history,
  });

  factory ClientById.fromJson(Map<String, dynamic> json) {
    return ClientById(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      subDomain: json['sub_domain'],
      tariffId: json['tariff_id'],
      saleId: json['sale_id'],
      balance: json['balance'],
      isActive: json['is_active'],
      isDemo: json['is_demo'],
      email: json['email'],
      clientType: json['client_type'] ?? '',
      contactPerson: json['contact_person'],
      partnerId: json['partner_id'],
      nfr: json['nfr'] ?? 0,
      rejectCause: json['reject_cause'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      lastActivity: json['last_activity'] != null 
          ? DateTime.parse(json['last_activity']) 
          : null,
      tariff: json['tariff'] != null 
          ? Tariff.fromJson(json['tariff']) 
          : Tariff( 
              id: 0,
              name: 'Unknown',
              price: 0,
              userCount: 0,
              projectCount: 0,
            ),
      businessType: json['business_type'] != null
          ? BusinessType.fromJson(json['business_type'])
          : null,
      sale: json['sale'] != null
          ? Sale.fromJson(json['sale'])
          : null,
      history: (json['history'] as List?)
          ?.map((e) => HistoryEntry.fromJson(e))
          .toList() ?? [],
    );
  }
}

class TransactionList {
  final int currentPage;
  final List<Transaction> data;
  final int total;

  TransactionList({
    required this.currentPage,
    required this.data,
    required this.total,
  });

  factory TransactionList.fromJson(Map<String, dynamic> json) {
    return TransactionList(
      currentPage: json['current_page'],
      data: (json['data'] as List)
          .map((e) => Transaction.fromJson(e))
          .toList(),
      total: json['total'],
    );
  }
}

class Transaction {
  final int id;
  final int clientId;
  final int? tariffId;
  final int? saleId;
  final String sum;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? organizationId;
  final Tariff? tariff;
  final ClientById client;
  final Sale? sale;

  Transaction({
    required this.id,
    required this.clientId,
    this.tariffId,
    this.saleId,
    required this.sum,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.organizationId,
    this.tariff,
    required this.client,
    this.sale,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      clientId: json['client_id'],
      tariffId: json['tariff_id'],
      saleId: json['sale_id'],
      sum: json['sum'],
      type: json['type'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      organizationId: json['organization_id'],
      tariff: json['tariff'] != null ? Tariff.fromJson(json['tariff']) : null,
      client: ClientById.fromJson(json['client']),
      sale: json['sale'] != null ? Sale.fromJson(json['sale']) : null,
    );
  }
}

class BusinessType {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  BusinessType({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BusinessType.fromJson(Map<String, dynamic> json) {
    return BusinessType(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Sale {
  final int id;
  final String name;
  final String saleType;
  final String amount;
  final int active;
  final DateTime createdAt;
  final DateTime updatedAt;

  Sale({
    required this.id,
    required this.name,
    required this.saleType,
    required this.amount,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      name: json['name'],
      saleType: json['sale_type'],
      amount: json['amount'],
      active: json['active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Pack {
  final int id;
  final String name;
  final String type;
  final int amount;
  final int tariffId;
  final String price;
  final DateTime createdAt;
  final DateTime updatedAt;

  Pack({
    required this.id,
    required this.name,
    required this.type,
    required this.amount,
    required this.tariffId,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pack.fromJson(Map<String, dynamic> json) {
    return Pack(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      amount: json['amount'],
      tariffId: json['tariff_id'],
      price: json['price'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class HistoryEntry {
  final int id;
  final int userId;
  final String status;
  final int modelId;
  final String modelType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<HistoryChange> changes;
  final HistoryUser user;

  HistoryEntry({
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

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
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

// Existing models (updated with new fields from response)

class Tariff {
  final int id;
  final String name;
  final int price;
  final int userCount;
  final int projectCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
      id: json['id'],
      name: json['name'],
      price: json['price'],
      userCount: json['user_count'],
      projectCount: json['project_count'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }
}

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
