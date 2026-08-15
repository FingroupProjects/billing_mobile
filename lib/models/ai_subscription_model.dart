int _parseInt(dynamic value, [int fallback = 0]) {
  if (value == null) return fallback;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString().trim()) ?? fallback;
}

String _parseString(dynamic value, [String fallback = '']) {
  if (value == null) return fallback;
  final text = value.toString();
  return text == 'null' ? fallback : text;
}

bool _parseBool(dynamic value, [bool fallback = false]) {
  if (value == null) return fallback;
  if (value is bool) return value;
  if (value is num) return value != 0;
  final text = value.toString().trim().toLowerCase();
  if (text == 'true' || text == '1' || text == 'active') return true;
  if (text == 'false' || text == '0' || text == 'inactive') return false;
  return fallback;
}

Map<String, dynamic>? _asStringMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return value.cast<String, dynamic>();
  return null;
}

Map<String, dynamic>? _unwrapProperties(dynamic value) {
  final map = _asStringMap(value);
  if (map == null) return null;
  return _asStringMap(map['properties']) ?? map;
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  if (text.isEmpty || text == 'null') return null;
  return DateTime.tryParse(text);
}

class AiSubscriptionListResponse {
  final int currentPage;
  final List<AiSubscription> data;
  final int total;
  final int lastPage;

  AiSubscriptionListResponse({
    required this.currentPage,
    required this.data,
    required this.total,
    required this.lastPage,
  });

  factory AiSubscriptionListResponse.fromJson(dynamic json) {
    final paginator = _findPaginator(json);
    final items = <AiSubscription>[];

    final rawData = paginator?['data'];
    if (rawData is List) {
      for (final item in rawData) {
        final map = _asStringMap(item);
        if (map == null) continue;
        try {
          items.add(AiSubscription.fromJson(map));
        } catch (_) {}
      }
    }

    return AiSubscriptionListResponse(
      currentPage: _parseInt(paginator?['current_page'], 1),
      data: items,
      total: _parseInt(paginator?['total'], items.length),
      lastPage: _parseInt(paginator?['last_page'], 1),
    );
  }
}

Map<String, dynamic>? _findPaginator(dynamic json) {
  final root = _asStringMap(json);
  if (root == null) return null;

  final data = _asStringMap(root['data']);
  final result = _asStringMap(root['result']);
  final candidates = <dynamic>[
    root,
    data,
    result,
    root['subscriptions'],
    data?['subscriptions'],
    result?['subscriptions'],
  ];

  for (final candidate in candidates) {
    final map = _unwrapProperties(candidate);
    if (map == null) continue;
    if (map['data'] is List || map['current_page'] != null) {
      return map;
    }
  }

  return root;
}

class AiSubscription {
  final int id;
  final int organizationId;
  final int planId;
  final bool status;
  final int periodMonths;
  final String pricePaid;
  final DateTime? startedAt;
  final DateTime? expiresAt;
  final DateTime? lastCrmFetchAt;
  final AiOrganization? organization;
  final AiPlan? plan;
  final AiBalance? aiBalance;

  AiSubscription({
    required this.id,
    required this.organizationId,
    required this.planId,
    required this.status,
    required this.periodMonths,
    required this.pricePaid,
    this.startedAt,
    this.expiresAt,
    this.lastCrmFetchAt,
    this.organization,
    this.plan,
    this.aiBalance,
  });

  factory AiSubscription.fromJson(Map<String, dynamic> json) {
    final organization = _asStringMap(json['organization']);
    final plan = _asStringMap(json['plan']);
    final balance = _asStringMap(json['ai_balance']) ??
        _asStringMap(json['balance']) ??
        _asStringMap(json['aiBalance']);

    return AiSubscription(
      id: _parseInt(json['id']),
      organizationId: _parseInt(json['organization_id']),
      planId: _parseInt(json['plan_id']),
      status: _parseBool(json['status']),
      periodMonths: _parseInt(json['period_months']),
      pricePaid: _parseString(json['price_paid'], '0'),
      startedAt: _parseDate(json['started_at']),
      expiresAt: _parseDate(json['expires_at']),
      lastCrmFetchAt: _parseDate(json['last_crm_fetch_at']),
      organization:
          organization == null ? null : AiOrganization.fromJson(organization),
      plan: plan == null ? null : AiPlan.fromJson(plan),
      aiBalance: balance == null ? null : AiBalance.fromJson(balance),
    );
  }

  AiSubscription merge(AiSubscription other) {
    return AiSubscription(
      id: other.id != 0 ? other.id : id,
      organizationId:
          other.organizationId != 0 ? other.organizationId : organizationId,
      planId: other.planId != 0 ? other.planId : planId,
      status: other.status,
      periodMonths: other.periodMonths != 0 ? other.periodMonths : periodMonths,
      pricePaid: other.pricePaid.isNotEmpty ? other.pricePaid : pricePaid,
      startedAt: other.startedAt ?? startedAt,
      expiresAt: other.expiresAt ?? expiresAt,
      lastCrmFetchAt: other.lastCrmFetchAt ?? lastCrmFetchAt,
      organization: other.organization ?? organization,
      plan: other.plan ?? plan,
      aiBalance: other.aiBalance ?? aiBalance,
    );
  }

  String get organizationName => organization?.name ?? '';

  String get planName => plan?.name ?? '';

  String get organizationPhone => organization?.phone ?? '';

  double get limitedBalance => aiBalance?.limitedBalanceValue ?? 0;

  double get walletBalance => aiBalance?.aiBalanceValue ?? 0;

  double get totalBalance => limitedBalance + walletBalance;
}

class AiOrganization {
  final int id;
  final String name;
  final String phone;
  final String email;

  AiOrganization({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  factory AiOrganization.fromJson(Map<String, dynamic> json) {
    return AiOrganization(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      phone: _parseString(json['phone']),
      email: _parseString(json['email']),
    );
  }
}

class AiPlan {
  final int id;
  final String name;

  AiPlan({
    required this.id,
    required this.name,
  });

  factory AiPlan.fromJson(Map<String, dynamic> json) {
    return AiPlan(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
    );
  }
}

class AiBalance {
  final int id;
  final String limitedBalance;
  final String aiBalance;
  final bool isAgentEnabled;

  AiBalance({
    required this.id,
    required this.limitedBalance,
    required this.aiBalance,
    required this.isAgentEnabled,
  });

  factory AiBalance.fromJson(Map<String, dynamic> json) {
    return AiBalance(
      id: _parseInt(json['id']),
      limitedBalance: _parseString(json['limited_balance'], '0'),
      aiBalance: _parseString(json['ai_balance'], '0'),
      isAgentEnabled: _parseBool(json['is_agent_enabled']),
    );
  }

  double get limitedBalanceValue =>
      double.tryParse(limitedBalance) ?? 0;

  double get aiBalanceValue => double.tryParse(aiBalance) ?? 0;
}

List<dynamic> _extractList(dynamic source) {
  if (source is List) return source;
  if (source is! Map) return const [];

  final map = source.cast<String, dynamic>();
  if (map['properties'] is List) return map['properties'] as List;
  final properties = _asStringMap(map['properties']);
  if (properties?['data'] is List) return properties!['data'] as List;
  if (map['data'] is List) return map['data'] as List;
  return const [];
}

class AiSubscriptionDetails {
  final AiSubscription subscription;
  final List<AiBalanceTransaction> transactions;
  final List<AiUsagePeriod> usageLogs;

  AiSubscriptionDetails({
    required this.subscription,
    this.transactions = const [],
    this.usageLogs = const [],
  });
}

class AiBalanceTransaction {
  final int id;
  final String type;
  final String targetBalance;
  final String amount;
  final String description;
  final String currencyCode;
  final DateTime? createdAt;

  AiBalanceTransaction({
    required this.id,
    required this.type,
    required this.targetBalance,
    required this.amount,
    required this.description,
    required this.currencyCode,
    this.createdAt,
  });

  factory AiBalanceTransaction.fromJson(Map<String, dynamic> json) {
    final currency = _asStringMap(json['currency']);
    return AiBalanceTransaction(
      id: _parseInt(json['id']),
      type: _parseString(json['type']),
      targetBalance: _parseString(json['target_balance']),
      amount: _parseString(json['amount'], '0'),
      description: _parseString(json['description']),
      currencyCode: _parseString(currency?['symbol_code'], 'USD'),
      createdAt: _parseDate(json['created_at']),
    );
  }

  double get amountValue => double.tryParse(amount) ?? 0;
}

class AiUsagePeriod {
  final int id;
  final String totalCost;
  final String deductedFromLimited;
  final String deductedFromAiBalance;
  final String currencyCode;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final List<AiUsageRequest> requests;

  AiUsagePeriod({
    required this.id,
    required this.totalCost,
    required this.deductedFromLimited,
    required this.deductedFromAiBalance,
    required this.currencyCode,
    this.periodStart,
    this.periodEnd,
    this.requests = const [],
  });

  factory AiUsagePeriod.fromJson(Map<String, dynamic> json) {
    final currency = _asStringMap(json['currency']);
    final requests = <AiUsageRequest>[];
    for (final item in _extractList(json['raw_logs'])) {
      final map = _asStringMap(item);
      if (map == null) continue;
      try {
        requests.add(AiUsageRequest.fromJson(map));
      } catch (_) {}
    }

    return AiUsagePeriod(
      id: _parseInt(json['id']),
      totalCost: _parseString(json['total_cost'], '0'),
      deductedFromLimited: _parseString(json['deducted_from_limited'], '0'),
      deductedFromAiBalance: _parseString(json['deducted_from_ai_balance'], '0'),
      currencyCode: _parseString(currency?['symbol_code'], 'USD'),
      periodStart: _parseDate(json['period_start']),
      periodEnd: _parseDate(json['period_end']),
      requests: requests,
    );
  }

  double get totalCostValue => double.tryParse(totalCost) ?? 0;

  double get limitedValue => double.tryParse(deductedFromLimited) ?? 0;

  double get aiAccountValue => double.tryParse(deductedFromAiBalance) ?? 0;
}

class AiUsageRequest {
  final int id;
  final String modelName;
  final int promptTokens;
  final int cacheTokens;
  final int completionTokens;
  final String calculatedCost;
  final DateTime? createdAt;

  AiUsageRequest({
    required this.id,
    required this.modelName,
    required this.promptTokens,
    required this.cacheTokens,
    required this.completionTokens,
    required this.calculatedCost,
    this.createdAt,
  });

  factory AiUsageRequest.fromJson(Map<String, dynamic> json) {
    return AiUsageRequest(
      id: _parseInt(json['id']),
      modelName: _parseString(json['model_name']),
      promptTokens: _parseInt(json['prompt_tokens']),
      cacheTokens: _parseInt(json['prompt_cache_hit_tokens']),
      completionTokens: _parseInt(json['completion_tokens']),
      calculatedCost: _parseString(json['calculated_cost'], '0'),
      createdAt: _parseDate(json['created_at']),
    );
  }

  double get costValue => double.tryParse(calculatedCost) ?? 0;
}

AiSubscriptionDetails parseAiSubscriptionDetails(
  dynamic json, {
  AiSubscription? fallback,
}) {
  final root = _asStringMap(json);
  final data = _asStringMap(root?['data']) ??
      _asStringMap(root?['result']) ??
      root ??
      <String, dynamic>{};

  final subscriptionMap = _asStringMap(data['aiSubscription']) ??
      _asStringMap(data['ai_subscription']) ??
      _asStringMap(data['subscription']) ??
      (data['id'] != null ? data : null);

  final balanceMap = _asStringMap(data['balance']) ??
      _asStringMap(data['ai_balance']) ??
      _asStringMap(data['aiBalance']);

  AiSubscription? subscription;
  if (subscriptionMap != null) {
    final merged = Map<String, dynamic>.from(subscriptionMap);
    if (balanceMap != null && merged['ai_balance'] == null) {
      merged['ai_balance'] = balanceMap;
    }
    try {
      final parsed = AiSubscription.fromJson(merged);
      subscription = fallback == null ? parsed : fallback.merge(parsed);
    } catch (_) {
      subscription = fallback;
    }
  } else if (fallback != null && balanceMap != null) {
    subscription = fallback.merge(
      AiSubscription(
        id: fallback.id,
        organizationId: fallback.organizationId,
        planId: fallback.planId,
        status: fallback.status,
        periodMonths: fallback.periodMonths,
        pricePaid: fallback.pricePaid,
        startedAt: fallback.startedAt,
        expiresAt: fallback.expiresAt,
        lastCrmFetchAt: fallback.lastCrmFetchAt,
        organization: fallback.organization,
        plan: fallback.plan,
        aiBalance: AiBalance.fromJson(balanceMap),
      ),
    );
  } else {
    subscription = fallback;
  }

  final transactions = <AiBalanceTransaction>[];
  for (final item in _extractList(
    data['transactions'] ?? root?['transactions'],
  )) {
    final map = _asStringMap(item);
    if (map == null) continue;
    try {
      transactions.add(AiBalanceTransaction.fromJson(map));
    } catch (_) {}
  }

  final usageLogs = <AiUsagePeriod>[];
  for (final item in _extractList(
    data['usageLogs'] ??
        data['usage_logs'] ??
        root?['usageLogs'] ??
        root?['usage_logs'],
  )) {
    final map = _asStringMap(item);
    if (map == null) continue;
    try {
      usageLogs.add(AiUsagePeriod.fromJson(map));
    } catch (_) {}
  }

  return AiSubscriptionDetails(
    subscription: subscription ??
        fallback ??
        AiSubscription(
          id: 0,
          organizationId: 0,
          planId: 0,
          status: false,
          periodMonths: 0,
          pricePaid: '0',
        ),
    transactions: transactions,
    usageLogs: usageLogs,
  );
}
