import 'package:billing_mobile/custom_widget/filter/filter_ui.dart';
import 'package:flutter/material.dart';

class RequestTypeData {
  final String id;
  final String name;

  RequestTypeData({required this.id, required this.name});
}

class RequestTypeList extends StatelessWidget {
  final String? selectedRequestType;
  final ValueChanged<String?> onChanged;

  const RequestTypeList({
    super.key,
    required this.selectedRequestType,
    required this.onChanged,
  });

  static final List<RequestTypeData> requestTypes = [
    RequestTypeData(id: 'connection', name: 'Подключение'),
    RequestTypeData(
      id: 'connection_extra_services',
      name: 'Подключение доп услуг',
    ),
    RequestTypeData(
      id: 'renewal',
      name: 'Продление (изменение)',
    ),
    RequestTypeData(
      id: 'renewal_no_changes',
      name: 'Продление',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final dropdownItems = requestTypes.map((type) {
      return DropdownMenuItem<String>(
        value: type.id,
        child: Text(
          type.name,
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
          'Тип подключения',
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
                  item.value == selectedRequestType &&
                  selectedRequestType != null &&
                  selectedRequestType!.isNotEmpty)
              ? selectedRequestType
              : null,
          hint: const Text(
            'Выберите тип подключения',
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
