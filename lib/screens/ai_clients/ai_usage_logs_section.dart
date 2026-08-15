import 'package:billing_mobile/models/ai_subscription_model.dart';
import 'package:billing_mobile/screens/ai_clients/ai_display.dart';
import 'package:flutter/material.dart';

class AiUsageLogsSection extends StatefulWidget {
  final List<AiUsagePeriod> usageLogs;

  const AiUsageLogsSection({
    super.key,
    required this.usageLogs,
  });

  @override
  State<AiUsageLogsSection> createState() => _AiUsageLogsSectionState();
}

class _AiUsageLogsSectionState extends State<AiUsageLogsSection> {
  bool _isExpanded = false;
  final Set<int> _expandedIds = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
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
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    '30-минутные расчёты',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1E2E52),
                    ),
                  ),
                ),
                if (widget.usageLogs.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      '${widget.usageLogs.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w500,
                        color: Color(0xff99A4BA),
                      ),
                    ),
                  ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: const Color(0xff1E2E52),
                ),
              ],
            ),
          ),
          if (_isExpanded) ...[
            const SizedBox(height: 6),
            const Text(
              'Нажмите на период, чтобы увидеть запросы',
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Gilroy',
                color: Color(0xff99A4BA),
              ),
            ),
            const SizedBox(height: 12),
            if (widget.usageLogs.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Нет расчётов',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                    color: Color(0xff99A4BA),
                  ),
                ),
              )
            else
              ...widget.usageLogs.map((period) {
              final expanded = _expandedIds.contains(period.id);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _PeriodCard(
                  period: period,
                  expanded: expanded,
                  onTap: () {
                    setState(() {
                      if (expanded) {
                        _expandedIds.remove(period.id);
                      } else {
                        _expandedIds.add(period.id);
                      }
                    });
                  },
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _PeriodCard extends StatelessWidget {
  final AiUsagePeriod period;
  final bool expanded;
  final VoidCallback onTap;

  const _PeriodCard({
    required this.period,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffEEF2F8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        AiDisplay.period(period.periodStart, period.periodEnd),
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                          color: Color(0xff1E2E52),
                        ),
                      ),
                    ),
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: const Color(0xff1E2E52),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        AiDisplay.usd(period.totalCostValue, decimals: 6),
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w700,
                          color: Color(0xff1E2E52),
                        ),
                      ),
                    ),
                    Text(
                      '${period.requests.length} зап.',
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w500,
                        color: Color(0xff99A4BA),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'С лимита: ${AiDisplay.usd(period.limitedValue, decimals: 6)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Gilroy',
                    color: Color(0xff99A4BA),
                  ),
                ),
                Text(
                  'С ИИ-счёта: ${AiDisplay.usd(period.aiAccountValue, decimals: 6)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Gilroy',
                    color: Color(0xff99A4BA),
                  ),
                ),
              ],
            ),
          ),
          if (expanded) ...[
            const SizedBox(height: 10),
            const Divider(height: 1, color: Color(0xffEEF2F8)),
            const SizedBox(height: 10),
            if (period.requests.isEmpty)
              const Text(
                'Нет запросов за период',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Gilroy',
                  color: Color(0xff99A4BA),
                ),
              )
            else
              ...period.requests.map(
                (request) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _RequestCard(request: request),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final AiUsageRequest request;

  const _RequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xffEEF2F8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AiDisplay.dateTime(request.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Gilroy',
                    color: Color(0xff99A4BA),
                  ),
                ),
              ),
              Text(
                AiDisplay.usd(request.costValue, decimals: 6),
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1E2E52),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            request.modelName,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
              color: Color(0xffC2185B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Вход: ${AiDisplay.tokens(request.promptTokens, request.cacheTokens)}',
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Gilroy',
              color: Color(0xff1E2E52),
            ),
          ),
          Text(
            'Выход: ${AiDisplay.tokens(request.completionTokens, 0)}',
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Gilroy',
              color: Color(0xff1E2E52),
            ),
          ),
        ],
      ),
    );
  }
}
