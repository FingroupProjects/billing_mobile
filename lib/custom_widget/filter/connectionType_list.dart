import 'package:flutter/material.dart';
import 'package:billing_mobile/custom_widget/filter/filter_ui.dart';

class ConnectionTypedata {
  final int id;
  final String name;

  ConnectionTypedata({required this.id, required this.name});
}

class ConnectionTypeList extends StatefulWidget {
  final String? selectedstatus;
  final ValueChanged<String?> onChanged;

  ConnectionTypeList({required this.selectedstatus, required this.onChanged});

  @override
  _ConnectionTypeListState createState() => _ConnectionTypeListState();
}

class _ConnectionTypeListState extends State<ConnectionTypeList> {
  final List<ConnectionTypedata> conTypeList = [
    ConnectionTypedata( id: 1, name: "Демо" ),
    ConnectionTypedata( id: 0, name: "Базовый" ),
  ];

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> dropdownItems = conTypeList.map<DropdownMenuItem<String>>((ConnectionTypedata status) {
      return DropdownMenuItem<String>(
        value: status.id.toString(),
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

    if (conTypeList.length == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged(conTypeList.first.id.toString());
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text( 'Тип подключения',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            fontFamily: 'Gilroy',
            color: kFilterTextColor,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: dropdownItems.any((item) => item.value == widget.selectedstatus)
              ? widget.selectedstatus
              : null,
          hint: const Text( 'Выберите статус',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Gilroy',
              color: kFilterTextColor,
            ),
          ),
          items: dropdownItems,
          onChanged: widget.onChanged,
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
