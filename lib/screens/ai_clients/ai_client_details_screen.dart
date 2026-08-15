import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/models/ai_subscription_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AiClientDetailsScreen extends StatefulWidget {
  final AiSubscription subscription;

  const AiClientDetailsScreen({
    super.key,
    required this.subscription,
  });

  @override
  State<AiClientDetailsScreen> createState() => _AiClientDetailsScreenState();
}

class _AiClientDetailsScreenState extends State<AiClientDetailsScreen> {
  final ApiService _apiService = ApiService();
  late AiSubscription _subscription;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _subscription = widget.subscription;
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    setState(() {
      _isRefreshing = true;
    });

    final details = await _apiService.getAiSubscriptionById(
      widget.subscription.id,
      fallback: widget.subscription,
    );

    if (!mounted) return;
    setState(() {
      _subscription = details ?? widget.subscription;
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        title: const Text(
          'ИИ-клиент',
          style: TextStyle(
            color: Color(0xff1E2E52),
            fontSize: 20,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xff1E2E52)),
      ),
      body: RefreshIndicator(
        color: const Color(0xff1E2E52),
        backgroundColor: Colors.white,
        onRefresh: _loadDetails,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            if (_isRefreshing)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: LinearProgressIndicator(
                  color: Color(0xff1E2E52),
                  backgroundColor: Color(0xffE5EAF3),
                ),
              ),
            _InfoCard(
              title: 'Подписка',
              rows: [
                _CardRowData(
                  label: 'Организация',
                  value: _subscription.organizationName,
                ),
                _CardRowData(
                  label: 'Тарифный план',
                  value: _subscription.planName,
                ),
                _CardRowData(
                  label: 'Период',
                  value: '${_subscription.periodMonths} мес.',
                ),
                _CardRowData(
                  label: 'Оплачено',
                  value: _formatPaid(_subscription.pricePaid),
                ),
                _CardRowData(
                  label: 'Статус',
                  badge: _StatusBadge(
                    text: _subscription.status ? 'Активна' : 'Неактивна',
                    isActive: _subscription.status,
                  ),
                ),
                _CardRowData(
                  label: 'Начало',
                  value: _formatDateTime(_subscription.startedAt),
                ),
                _CardRowData(
                  label: 'Окончание',
                  value: _formatDateTime(_subscription.expiresAt),
                ),
                _CardRowData(
                  label: 'Последний фетч CRM',
                  value: _formatDateTime(_subscription.lastCrmFetchAt),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _InfoCard(
              title: 'Баланс ИИ',
              rows: [
                _CardRowData(
                  label: 'Лимит',
                  value: _formatUsd(_subscription.limitedBalance),
                  valueColor: const Color(0xff22A06B),
                ),
                _CardRowData(
                  label: 'ИИ-счёт',
                  value: _formatUsd(_subscription.walletBalance),
                  valueColor: const Color(0xff22A06B),
                ),
                _CardRowData(
                  label: 'Итого',
                  value: _formatUsd(_subscription.totalBalance),
                  isStrong: true,
                ),
                _CardRowData(
                  label: 'Агент',
                  badge: _StatusBadge(
                    text: (_subscription.aiBalance?.isAgentEnabled ?? false)
                        ? 'Включён'
                        : 'Выключен',
                    isActive:
                        _subscription.aiBalance?.isAgentEnabled ?? false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CardRowData {
  final String label;
  final String? value;
  final Widget? badge;
  final Color? valueColor;
  final bool isStrong;

  const _CardRowData({
    required this.label,
    this.value,
    this.badge,
    this.valueColor,
    this.isStrong = false,
  });
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<_CardRowData> rows;

  const _InfoCard({
    required this.title,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffE5EAF3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D1E2E52),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
              color: Color(0xff1E2E52),
            ),
          ),
          const SizedBox(height: 8),
          ...rows.asMap().entries.map((entry) {
            final isLast = entry.key == rows.length - 1;
            return _CardRow(data: entry.value, showDivider: !isLast);
          }),
        ],
      ),
    );
  }
}

class _CardRow extends StatelessWidget {
  final _CardRowData data;
  final bool showDivider;

  const _CardRow({
    required this.data,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  data.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w400,
                    color: Color(0xff99A4BA),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (data.badge != null)
                data.badge!
              else
                Flexible(
                  child: Text(
                    data.value ?? '',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Gilroy',
                      fontWeight:
                          data.isStrong ? FontWeight.w700 : FontWeight.w500,
                      color: data.valueColor ?? const Color(0xff1E2E52),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xffEEF2F8),
          ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String text;
  final bool isActive;

  const _StatusBadge({
    required this.text,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xffE8F8F0) : const Color(0xffF1F3F7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? const Color(0xff22A06B) : const Color(0xff99A4BA),
          fontSize: 12,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

String _formatDateTime(DateTime? value) {
  if (value == null) return '—';
  return DateFormat('dd.MM.yyyy HH:mm').format(value.toLocal());
}

String _formatPaid(String value) {
  final number = double.tryParse(value) ?? 0;
  return NumberFormat('#,##0.00', 'ru_RU').format(number);
}

String _formatUsd(double value) {
  return '${NumberFormat('#,##0.0000', 'ru_RU').format(value)} USD';
}
