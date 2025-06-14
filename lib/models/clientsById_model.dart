class ClientByIdResponse {
  final List<BusinessType> businessTypes;
  final List<Sale> sales;
  final List<Tariff> tariffs;
  final List<Pack> packs;
  final ClientById client;
  final String expirationDate;

  ClientByIdResponse({
    required this.businessTypes,
    required this.sales,
    required this.tariffs,
    required this.packs,
    required this.client,
   required this.expirationDate,
  });

  factory ClientByIdResponse.fromJson(Map<String, dynamic> json) {
    print('Starting ClientByIdResponse.fromJson with JSON: $json');
    print('Checking businessTypes in JSON: ${json['businessTypes']}');
    final businessTypesList = json['businessTypes'] as List? ?? [];
    print('businessTypes list resolved: $businessTypesList');
    final businessTypes = businessTypesList.map((e) => BusinessType.fromJson(e)).toList();
    print('businessTypes parsed: $businessTypes');

    print('Checking sales in JSON: ${json['sales']}');
    final salesList = json['sales'] as List? ?? [];
    print('sales list resolved: $salesList');
    final sales = salesList.map((e) => Sale.fromJson(e)).toList();
    print('sales parsed: $sales');

    print('Checking tariffs in JSON: ${json['tariffs']}');
    final tariffsList = json['tariffs'] as List? ?? [];
    print('tariffs list resolved: $tariffsList');
    final tariffs = tariffsList.map((e) => Tariff.fromJson(e)).toList();
    print('tariffs parsed: $tariffs');

    print('Checking packs in JSON: ${json['packs']}');
    final packsList = json['packs'] as List? ?? [];
    print('packs list resolved: $packsList');
    final packs = packsList.map((e) => Pack.fromJson(e)).toList();
    print('packs parsed: $packs');

    print('Checking client in JSON: ${json['client']}');
    final clientJson = json['client'] ?? {};
    print('client JSON resolved: $clientJson');
    final client = ClientById.fromJson(clientJson);
    print('client parsed: $client');

    print('Checking expirationDate in JSON: ${json['expirationDate']}');
    final expirationDate = json['expirationDate'] as String;
    print('expirationDate resolved: xpirationDate');

    print('Completed ClientByIdResponse.fromJson');
    return ClientByIdResponse(
      businessTypes: businessTypes,
      sales: sales,
      tariffs: tariffs,
      packs: packs,
      client: client,
      expirationDate: expirationDate,
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
  final String? clientType;
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
  final int? countryId;
  final String? countryName;
  final String? partnerName;
  final List<dynamic>? history;

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
    this.clientType,
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
    this.countryId,
    this.countryName,
    this.partnerName,
    this.history,
  });

  factory ClientById.fromJson(Map<String, dynamic> json) {
    print('Starting ClientById.fromJson with JSON: $json');
    print('Parsing id: ${json['id']}');
    final id = json['id'] as int? ?? 0;
    print('id parsed: $id');

    print('Parsing name: ${json['name']}');
    final name = json['name'] as String? ?? '';
    print('name parsed: $name');

    print('Parsing phone: ${json['phone']}');
    final phone = json['phone'] as String? ?? '';
    print('phone parsed: $phone');

    print('Parsing subDomain: ${json['sub_domain']}');
    final subDomain = json['sub_domain'] as String? ?? '';
    print('subDomain parsed: $subDomain');

    print('Parsing tariffId: ${json['tariff_id']}');
    final tariffId = json['tariff_id'] as int? ?? 0;
    print('tariffId parsed: $tariffId');

    print('Parsing saleId: ${json['sale_id']}');
    final saleId = json['sale_id'] as int?;
    print('saleId parsed: $saleId');

    print('Parsing balance: ${json['balance']}');
    final balance = json['balance'] as String? ?? '0.00';
    print('balance parsed: $balance');

    print('Parsing isActive: ${json['is_active']}');
    final isActive = json['is_active'] as bool? ?? false;
    print('isActive parsed: $isActive');

    print('Parsing isDemo: ${json['is_demo']}');
    final isDemo = json['is_demo'] as bool? ?? false;
    print('isDemo parsed: $isDemo');

    print('Parsing email: ${json['email']}');
    final email = json['email'] as String?;
    print('email parsed: mail');

    print('Parsing clientType: ${json['client_type']}');
    final clientType = json['client_type'] as String?;
    print('clientType parsed: $clientType');

    print('Parsing contactPerson: ${json['contact_person']}');
    final contactPerson = json['contact_person'] as String?;
    print('contactPerson parsed: $contactPerson');

    print('Parsing partnerId: ${json['partner_id']}');
    final partnerId = json['partner_id'] as int?;
    print('partnerId parsed: $partnerId');

    print('Parsing nfr: ${json['nfr']}');
    final nfr = json['nfr'] as int? ?? 0;
    print('nfr parsed: $nfr');

    print('Parsing rejectCause: ${json['reject_cause']}');
    final rejectCause = json['reject_cause'] as String?;
    print('rejectCause parsed: $rejectCause');

    print('Parsing createdAt: ${json['created_at']}');
    final createdAt = DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String());
    print('createdAt parsed: $createdAt');

    print('Parsing updatedAt: ${json['updated_at']}');
    final updatedAt = DateTime.parse(json['updated_at'] as String? ?? DateTime.now().toIso8601String());
    print('updatedAt parsed: $updatedAt');

    print('Parsing lastActivity: ${json['last_activity']}');
    final lastActivity = (json['last_activity'] as String?) != null ? DateTime.parse(json['last_activity'] as String) : null;
    print('lastActivity parsed: $lastActivity');

    print('Parsing tariff: ${json['tariff']}');
    final tariff = json['tariff'] != null ? Tariff.fromJson(json['tariff'] as Map<String, dynamic>) : Tariff(id: 0, name: 'Unknown', price: 0, userCount: 0, projectCount: 0);
    print('tariff parsed: $tariff');

    print('Parsing businessType: ${json['business_type']}');
    final businessType = json['business_type'] != null ? BusinessType.fromJson(json['business_type'] as Map<String, dynamic>) : null;
    print('businessType parsed: $businessType');

    print('Parsing sale: ${json['sale']}');
    final sale = json['sale'] != null ? Sale.fromJson(json['sale'] as Map<String, dynamic>) : null;
    print('sale parsed: $sale');

    print('Parsing countryId: ${json['country_id']}');
    final countryId = json['country_id'] as int?;
    print('countryId parsed: $countryId');

    print('Parsing countryName: ${json['country']}');
    final countryName = json['country'] != null ? json['country']['name'] as String? : null;
    print('countryName parsed: $countryName');

    print('Parsing partnerName: ${json['partner']}');
    final partnerName = json['partner'] != null ? json['partner']['name'] as String? : null;
    print('partnerName parsed: $partnerName');

    print('Parsing history: ${json['history']}');
    final history = json['history'] as List<dynamic>?;
    print('history parsed: $history');

    print('Completed ClientById.fromJson');
    return ClientById(
      id: id,
      name: name,
      phone: phone,
      subDomain: subDomain,
      tariffId: tariffId,
      saleId: saleId,
      balance: balance,
      isActive: isActive,
      isDemo: isDemo,
      email: email,
      clientType: clientType,
      contactPerson: contactPerson,
      partnerId: partnerId,
      nfr: nfr,
      rejectCause: rejectCause,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastActivity: lastActivity,
      tariff: tariff,
      businessType: businessType,
      sale: sale,
      countryId: countryId,
      countryName: countryName,
      partnerName: partnerName,
      history: history,
    );
  }
}

class BusinessType {
  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BusinessType({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory BusinessType.fromJson(Map<String, dynamic> json) {
    print('Starting BusinessType.fromJson with JSON: $json');
    print('Parsing id: ${json['id']}');
    final id = json['id'] as int? ?? 0;
    print('id parsed: $id');

    print('Parsing name: ${json['name']}');
    final name = json['name'] as String? ?? '';
    print('name parsed: $name');

    print('Parsing createdAt: ${json['created_at']}');
    final createdAt = (json['created_at'] as String?) != null ? DateTime.parse(json['created_at'] as String) : null;
    print('createdAt parsed: $createdAt');

    print('Parsing updatedAt: ${json['updated_at']}');
    final updatedAt = (json['updated_at'] as String?) != null ? DateTime.parse(json['updated_at'] as String) : null;
    print('updatedAt parsed: $updatedAt');

    print('Completed BusinessType.fromJson');
    return BusinessType(
      id: id,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class Sale {
  final int id;
  final String name;
  final String saleType;
  final String amount;
  final int active;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Sale({
    required this.id,
    required this.name,
    required this.saleType,
    required this.amount,
    required this.active,
    this.createdAt,
    this.updatedAt,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    print('Starting Sale.fromJson with JSON: $json');
    print('Parsing id: ${json['id']}');
    final id = json['id'] as int? ?? 0;
    print('id parsed: $id');

    print('Parsing name: ${json['name']}');
    final name = json['name'] as String? ?? '';
    print('name parsed: $name');

    print('Parsing saleType: ${json['sale_type']}');
    final saleType = json['sale_type'] as String? ?? '';
    print('saleType parsed: $saleType');

    print('Parsing amount: ${json['amount']}');
    final amount = json['amount'] as String? ?? '0.00';
    print('amount parsed: $amount');

    print('Parsing active: ${json['active']}');
    final active = json['active'] as int? ?? 0;
    print('active parsed: $active');

    print('Parsing createdAt: ${json['created_at']}');
    final createdAt = (json['created_at'] as String?) != null ? DateTime.parse(json['created_at'] as String) : null;
    print('createdAt parsed: $createdAt');

    print('Parsing updatedAt: ${json['updated_at']}');
    final updatedAt = (json['updated_at'] as String?) != null ? DateTime.parse(json['updated_at'] as String) : null;
    print('updatedAt parsed: $updatedAt');

    print('Completed Sale.fromJson');
    return Sale(
      id: id,
      name: name,
      saleType: saleType,
      amount: amount,
      active: active,
      createdAt: createdAt,
      updatedAt: updatedAt,
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
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? description;

  Pack({
    required this.id,
    required this.name,
    required this.type,
    required this.amount,
    required this.tariffId,
    required this.price,
    this.createdAt,
    this.updatedAt,
    this.description,
  });

  factory Pack.fromJson(Map<String, dynamic> json) {
    print('Starting Pack.fromJson with JSON: $json');
    print('Parsing id: ${json['id']}');
    final id = json['id'] as int? ?? 0;
    print('id parsed: $id');

    print('Parsing name: ${json['name']}');
    final name = json['name'] as String? ?? '';
    print('name parsed: $name');

    print('Parsing type: ${json['type']}');
    final type = json['type'] as String? ?? '';
    print('type parsed: $type');

    print('Parsing amount: ${json['amount']}');
    final amount = json['amount'] as int? ?? 0;
    print('amount parsed: $amount');

    print('Parsing tariffId: ${json['tariff_id']}');
    final tariffId = json['tariff_id'] as int? ?? 0;
    print('tariffId parsed: $tariffId');

    print('Parsing price: ${json['price']}');
    final price = json['price'] as String? ?? '0.00';
    print('price parsed: $price');

    print('Parsing createdAt: ${json['created_at']}');
    final createdAt = (json['created_at'] as String?) != null ? DateTime.parse(json['created_at'] as String) : null;
    print('createdAt parsed: $createdAt');

    print('Parsing updatedAt: ${json['updated_at']}');
    final updatedAt = (json['updated_at'] as String?) != null ? DateTime.parse(json['updated_at'] as String) : null;
    print('updatedAt parsed: $updatedAt');

    print('Parsing description: ${json['description']}');
    final description = json['description'] as String?;
    print('description parsed: $description');

    print('Completed Pack.fromJson');
    return Pack(
      id: id,
      name: name,
      type: type,
      amount: amount,
      tariffId: tariffId,
      price: price,
      createdAt: createdAt,
      updatedAt: updatedAt,
      description: description,
    );
  }
}

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
    print('Starting Tariff.fromJson with JSON: $json');
    print('Parsing id: ${json['id']}');
    final id = json['id'] as int? ?? 0;
    print('id parsed: $id');

    print('Parsing name: ${json['name']}');
    final name = json['name'] as String? ?? '';
    print('name parsed: $name');

    print('Parsing price: ${json['price']}');
    final price = json['price'] as int? ?? 0;
    print('price parsed: $price');

    print('Parsing userCount: ${json['user_count']}');
    final userCount = json['user_count'] as int? ?? 0;
    print('userCount parsed: $userCount');

    print('Parsing projectCount: ${json['project_count']}');
    final projectCount = json['project_count'] as int? ?? 0;
    print('projectCount parsed: $projectCount');

    print('Parsing createdAt: ${json['created_at']}');
    final createdAt = (json['created_at'] as String?) != null ? DateTime.parse(json['created_at'] as String) : null;
    print('createdAt parsed: $createdAt');

    print('Parsing updatedAt: ${json['updated_at']}');
    final updatedAt = (json['updated_at'] as String?) != null ? DateTime.parse(json['updated_at'] as String) : null;
    print('updatedAt parsed: $updatedAt');

    print('Completed Tariff.fromJson');
    return Tariff(
      id: id,
      name: name,
      price: price,
      userCount: userCount,
      projectCount: projectCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}