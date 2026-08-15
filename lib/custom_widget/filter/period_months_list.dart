import 'package:billing_mobile/custom_widget/filter/filter_ui.dart';
import 'package:flutter/material.dart';

class PeriodMonthsData {
  final int id;
  final String name;

  PeriodMonthsData({required this.id, required this.name});
}

class PeriodMonthsList extends StatelessWidget {
  final String? selectedPeriod;
  final ValueChanged<String?> onChanged;

  const PeriodMonthsList({
    super.key,
    required this.selectedPeriod,
    required this.onChanged,
  });

  static final List<PeriodMonthsData> periods = [
    PeriodMonthsData(id: 6, name: '6 мес.'),
    PeriodMonthsData(id: 12, name: '12 мес.'),
  ];

  @override
  Widget build(BuildContext context) {
    final dropdownItems = periods.map((period) {
      return DropdownMenuItem<String>(
        value: period.id.toString(),
        child: Text(
          period.name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Gilroy',
            color: Color(0xff1E2E52),
          ),
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Период оплаты',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            fontFamily: 'Gilroy',
            color: kFilterTextColor,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: dropdownItems.any((item) =>
                  item.value == selectedPeriod &&
                  selectedPeriod != null &&
                  selectedPeriod!.isNotEmpty)
              ? selectedPeriod
              : null,
          hint: const Text(
            'Выберите период оплаты',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Gilroy',
              color: kFilterTextColor,
            ),
          ),
          items: dropdownItems,
          onChanged: onChanged,
          decoration: buildFilterDropdownDecoration(),
          dropdownColor: Colors.white,
          icon: Image.asset(
            'assets/icons/dropdown.png',
            width: 16,
            height: 16,
          ),
        ),
      ],
    );
  }
}
