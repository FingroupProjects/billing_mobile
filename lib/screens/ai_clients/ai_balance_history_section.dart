import 'package:billing_mobile/models/ai_subscription_model.dart';
import 'package:billing_mobile/screens/ai_clients/ai_display.dart';
import 'package:flutter/material.dart';

class AiBalanceHistorySection extends StatefulWidget {
  final List<AiBalanceTransaction> transactions;

  const AiBalanceHistorySection({
    super.key,
    required this.transactions,
  });

  @override
  State<AiBalanceHistorySection> createState() =>
      _AiBalanceHistorySectionState();
}

class _AiBalanceHistorySectionState extends State<AiBalanceHistorySection> {
  bool _isExpanded = false;
  String? _selectedType;

  List<String> get _types {
    final types = <String>{};
    for (final item in widget.transactions) {
      if (item.type.isNotEmpty) types.add(item.type);
    }
    return types.toList();
  }

  List<AiBalanceTransaction> get _filtered {
    if (_selectedType == null) return widget.transactions;
    return widget.transactions
        .where((item) => item.type == _selectedType)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

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
                    'История движения баланса',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1E2E52),
                    ),
                  ),
                ),
                if (widget.transactions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      '${widget.transactions.length}',
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
          if (_isExpanded && _types.length > 1) ...[
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _TypeChip(
                    label: 'Все',
                    selected: _selectedType == null,
                    onTap: () => setState(() => _selectedType = null),
                  ),
                  ..._types.map(
                    (type) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _TypeChip(
                        label: AiDisplay.typeLabel(type),
                        color: AiDisplay.typeColor(type),
                        selected: _selectedType == type,
                        onTap: () => setState(() => _selectedType = type),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (_isExpanded) ...[
            const SizedBox(height: 12),
            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Нет операций',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                    color: Color(0xff99A4BA),
                  ),
                ),
              )
            else
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _TransactionCard(transaction: item),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  const _TypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? const Color(0xff1E2E52);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? activeColor : const Color(0xffF4F7FD),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xff1E2E52),
          ),
        ),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final AiBalanceTransaction transaction;

  const _TransactionCard({required this.transaction});

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  AiDisplay.dateTime(transaction.createdAt),
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500,
                    color: Color(0xff99A4BA),
                  ),
                ),
              ),
              Text(
                AiDisplay.usd(transaction.amountValue),
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1E2E52),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AiDisplay.typeBackground(transaction.type),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              AiDisplay.typeLabel(transaction.type),
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
                color: AiDisplay.typeColor(transaction.type),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AiDisplay.accountLabel(transaction.targetBalance),
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w500,
              color: Color(0xff1E2E52),
            ),
          ),
          if (transaction.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              transaction.description,
              style: const TextStyle(
                fontSize: 13,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w400,
                color: Color(0xff99A4BA),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
