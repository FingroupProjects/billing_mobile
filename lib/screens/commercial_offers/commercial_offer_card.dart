import 'package:billing_mobile/custom_widget/custom_card_tasks_tabBar.dart';
import 'package:billing_mobile/models/commercial_offer_model.dart';
import 'package:billing_mobile/screens/commercial_offers/commercial_offer_status_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommercialOfferCard extends StatelessWidget {
  final CommercialOffer offer;
  final VoidCallback? onTap;
  final VoidCallback? onStatusSaved;

  const CommercialOfferCard({
    super.key,
    required this.offer,
    this.onTap,
    this.onStatusSaved,
  });

  @override
  Widget build(BuildContext context) {
    final canConfirm =
        offer.status != 'paid' && offer.status != 'canceled';
    final createdDate = offer.createdAt != null
        ? DateFormat('dd.MM.yyyy').format(offer.createdAt!.toLocal())
        : '';

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
                    offer.clientName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TaskCardStyles.titleStyle.copyWith(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 8),
                _StatusBadge(status: offer.status),
              ],
            ),
            const SizedBox(height: 10),
            _InfoRow(label: 'Партнер: ', value: offer.partnerName),
            const SizedBox(height: 4),
            _InfoRow(label: 'Дата операции: ', value: createdDate),
            const SizedBox(height: 4),
            _InfoRow(
              label: 'Тариф: ',
              value: offer.tariff?.name ?? '',
            ),
            const SizedBox(height: 4),
            _InfoRow(
              label: 'Период: ',
              value: '${offer.periodMonths} мес.',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _AmountPill(
                    value:
                        '${_formatAmount(offer.payableTotal)} ${offer.payableCurrency}',
                  ),
                ),
                if (canConfirm) ...[
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 42,
                    child: ElevatedButton(
                      onPressed: () async {
                        final saved = await showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => CommercialOfferStatusDialog(
                            offerId: offer.id,
                          ),
                        );

                        if (saved == true) {
                          onStatusSaved?.call();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1E2E52),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Подтвердить',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _formatAmount(String value) {
    final number = double.tryParse(value) ?? 0;
    return NumberFormat('#,##0.00', 'ru_RU').format(number);
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _statusColor(status),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _statusText(status),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _statusText(String value) {
    switch (value) {
      case 'pending':
        return 'В ожидании';
      case 'paid':
        return 'Оплачено';
      case 'canceled':
        return 'Отменено';
      case 'rejected':
        return 'Отклонено';
      default:
        return value;
    }
  }

  Color _statusColor(String value) {
    switch (value) {
      case 'paid':
        return const Color(0xff22A06B);
      case 'canceled':
      case 'rejected':
        return const Color(0xffFF4D3D);
      case 'pending':
      default:
        return const Color(0xffFF4D3D);
    }
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
        color: const Color(0xFFF4F7FD),
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
