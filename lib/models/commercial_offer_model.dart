class CommercialOfferListResponse {
  final int currentPage;
  final List<CommercialOffer> data;
  final int total;
  final int lastPage;

  CommercialOfferListResponse({
    required this.currentPage,
    required this.data,
    required this.total,
    required this.lastPage,
  });

  factory CommercialOfferListResponse.fromJson(Map<String, dynamic> json) {
    return CommercialOfferListResponse(
      currentPage: json['current_page'] ?? 1,
      data: (json['data'] as List?)
              ?.map((e) => CommercialOffer.fromJson(e))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
    );
  }
}

class CommercialOffer {
  final int id;
  final int organizationId;
  final String status;
  final String requestType;
  final DateTime? statusDate;
  final DateTime? createdAt;
  final String currency;
  final String payableCurrency;
  final int periodMonths;
  final String clientName;
  final String clientPhone;
  final String clientEmail;
  final String partnerName;
  final String partnerPhone;
  final String partnerEmail;
  final String payerType;
  final String managerName;
  final String monthlyTotal;
  final String grandTotal;
  final String payableTotal;
  final String? paymentLink;
  final String? cardPaymentType;
  final CommercialOfferTariff? tariff;
  final CommercialOfferOrganization? organization;
  final CommercialOfferLatestStatus? latestOfferStatus;

  CommercialOffer({
    required this.id,
    required this.organizationId,
    required this.status,
    required this.requestType,
    this.statusDate,
    this.createdAt,
    required this.currency,
    required this.payableCurrency,
    required this.periodMonths,
    required this.clientName,
    required this.clientPhone,
    required this.clientEmail,
    required this.partnerName,
    required this.partnerPhone,
    required this.partnerEmail,
    required this.payerType,
    required this.managerName,
    required this.monthlyTotal,
    required this.grandTotal,
    required this.payableTotal,
    this.paymentLink,
    this.cardPaymentType,
    this.tariff,
    this.organization,
    this.latestOfferStatus,
  });

  factory CommercialOffer.fromJson(Map<String, dynamic> json) {
    return CommercialOffer(
      id: json['id'] ?? 0,
      organizationId: json['organization_id'] ?? 0,
      status: json['status'] ?? '',
      requestType: json['request_type'] ?? '',
      statusDate: _parseDate(json['status_date']),
      createdAt: _parseDate(json['created_at']),
      currency: json['currency'] ?? '',
      payableCurrency: json['payable_currency'] ?? '',
      periodMonths: json['period_months'] ?? 0,
      clientName: json['client_name'] ?? '',
      clientPhone: json['client_phone'] ?? '',
      clientEmail: json['client_email'] ?? '',
      partnerName: json['partner_name'] ?? '',
      partnerPhone: json['partner_phone'] ?? '',
      partnerEmail: json['partner_email'] ?? '',
      payerType: json['payer_type'] ?? '',
      managerName: json['manager_name'] ?? '',
      monthlyTotal: (json['monthly_total'] ?? '0').toString(),
      grandTotal: (json['grand_total'] ?? '0').toString(),
      payableTotal: (json['payable_total'] ?? '0').toString(),
      paymentLink: json['payment_link'],
      cardPaymentType: json['card_payment_type'],
      tariff: json['tariff'] is Map<String, dynamic>
          ? CommercialOfferTariff.fromJson(json['tariff'])
          : null,
      organization: json['organization'] is Map<String, dynamic>
          ? CommercialOfferOrganization.fromJson(json['organization'])
          : null,
      latestOfferStatus: json['latest_offer_status'] is Map<String, dynamic>
          ? CommercialOfferLatestStatus.fromJson(json['latest_offer_status'])
          : null,
    );
  }
}

class CommercialOfferTariff {
  final int id;
  final String name;

  CommercialOfferTariff({
    required this.id,
    required this.name,
  });

  factory CommercialOfferTariff.fromJson(Map<String, dynamic> json) {
    return CommercialOfferTariff(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class CommercialOfferOrganization {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String orderNumber;

  CommercialOfferOrganization({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.orderNumber,
  });

  factory CommercialOfferOrganization.fromJson(Map<String, dynamic> json) {
    return CommercialOfferOrganization(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      orderNumber: json['order_number'] ?? '',
    );
  }
}

class CommercialOfferLatestStatus {
  final int id;
  final String status;
  final DateTime? statusDate;
  final String paymentMethod;

  CommercialOfferLatestStatus({
    required this.id,
    required this.status,
    this.statusDate,
    required this.paymentMethod,
  });

  factory CommercialOfferLatestStatus.fromJson(Map<String, dynamic> json) {
    return CommercialOfferLatestStatus(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      statusDate: _parseDate(json['status_date']),
      paymentMethod: json['payment_method'] ?? '',
    );
  }
}

class CommercialOfferStatus {
  final int id;
  final int commercialOfferId;
  final String status;
  final DateTime? statusDate;
  final String paymentMethod;
  final String? paymentOrderNumber;
  final DateTime? createdAt;
  final CommercialOfferAuthor? author;
  final CommercialOfferAccount? account;

  CommercialOfferStatus({
    required this.id,
    required this.commercialOfferId,
    required this.status,
    this.statusDate,
    required this.paymentMethod,
    this.paymentOrderNumber,
    this.createdAt,
    this.author,
    this.account,
  });

  factory CommercialOfferStatus.fromJson(Map<String, dynamic> json) {
    return CommercialOfferStatus(
      id: json['id'] ?? 0,
      commercialOfferId: json['commercial_offer_id'] ?? 0,
      status: json['status'] ?? '',
      statusDate: _parseDate(json['status_date']),
      paymentMethod: json['payment_method'] ?? '',
      paymentOrderNumber: json['payment_order_number'],
      createdAt: _parseDate(json['created_at']),
      author: json['author'] is Map<String, dynamic>
          ? CommercialOfferAuthor.fromJson(json['author'])
          : null,
      account: json['account'] is Map<String, dynamic>
          ? CommercialOfferAccount.fromJson(json['account'])
          : null,
    );
  }
}

class CommercialOfferAuthor {
  final int id;
  final String name;

  CommercialOfferAuthor({
    required this.id,
    required this.name,
  });

  factory CommercialOfferAuthor.fromJson(Map<String, dynamic> json) {
    return CommercialOfferAuthor(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class CommercialOfferAccount {
  final int id;
  final String name;
  final String currencyCode;

  CommercialOfferAccount({
    required this.id,
    required this.name,
    required this.currencyCode,
  });

  factory CommercialOfferAccount.fromJson(Map<String, dynamic> json) {
    return CommercialOfferAccount(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      currencyCode: json['currency']?['symbol_code'] ?? '',
    );
  }
}

extension CommercialOfferAccountTitle on CommercialOfferAccount {
  String get title {
    if (currencyCode.isEmpty) return name;
    return '$name ($currencyCode)';
  }
}

DateTime? _parseDate(dynamic value) {
  if (value == null || value.toString().isEmpty) return null;
  return DateTime.tryParse(value.toString());
}
