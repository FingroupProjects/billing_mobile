import 'package:billing_mobile/custom_widget/custom_card_tasks_tabBar.dart';
import 'package:billing_mobile/models/ai_subscription_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AiClientCard extends StatelessWidget {
  final AiSubscription subscription;
  final VoidCallback? onTap;

  const AiClientCard({
    super.key,
    required this.subscription,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: TaskCardStyles.taskCardDecoration.copyWith(
          border: Border.all(
            color: const Color(0xffE5EAF3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    subscription.organizationName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TaskCardStyles.titleStyle.copyWith(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 8),
                _StatusBadge(isActive: subscription.status),
              ],
            ),
            const SizedBox(height: 10),
            _InfoRow(label: 'Тариф: ', value: subscription.planName),
            const SizedBox(height: 4),
            _InfoRow(
              label: 'Период: ',
              value: '${subscription.periodMonths} мес.',
            ),
            if (subscription.organizationPhone.isNotEmpty) ...[
              const SizedBox(height: 4),
              _InfoRow(
                label: 'Телефон: ',
                value: subscription.organizationPhone,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _AmountPill(
                    value: _formatBalance(subscription.totalBalance),
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

class _StatusBadge extends StatelessWidget {
  final bool isActive;

  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xff22A06B) : const Color(0xff99A4BA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'Активна' : 'Неактивна',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w400,
              color: Color(0xff99A4BA),
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w500,
              color: Color(0xff1E2E52),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountPill extends StatelessWidget {
  final String value;

  const _AmountPill({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Color(0xff1E2E52),
          fontSize: 14,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

String _formatBalance(double value) {
  return '${NumberFormat('#,##0.0000', 'ru_RU').format(value)} USD';
}
