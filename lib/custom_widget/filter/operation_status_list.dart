import 'package:billing_mobile/custom_widget/filter/filter_ui.dart';
import 'package:flutter/material.dart';

class OperationStatusData {
  final String id;
  final String name;

  OperationStatusData({required this.id, required this.name});
}

class OperationStatusList extends StatelessWidget {
  final String? selectedStatus;
  final ValueChanged<String?> onChanged;

  const OperationStatusList({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
  });

  static final List<OperationStatusData> statuses = [
    OperationStatusData(id: 'draft', name: 'Черновик'),
    OperationStatusData(id: 'pending', name: 'В ожидании'),
    OperationStatusData(id: 'paid', name: 'Оплачено'),
    OperationStatusData(id: 'canceled', name: 'Отменено'),
  ];

  @override
  Widget build(BuildContext context) {
    final dropdownItems = statuses.map((status) {
      return DropdownMenuItem<String>(
        value: status.id,
        child: Text(
          status.name,
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
          'Статус операции',
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
                  item.value == selectedStatus &&
                  selectedStatus != null &&
                  selectedStatus!.isNotEmpty)
              ? selectedStatus
              : null,
          hint: const Text(
            'Выберите статус операции',
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
