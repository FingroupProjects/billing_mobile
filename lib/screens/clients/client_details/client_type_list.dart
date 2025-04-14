import 'package:flutter/material.dart';

class ClientType {
  final String name;

  ClientType({ required this.name});
}

class ClientTypeList extends StatefulWidget {
  final String? selectedClientType;
  final ValueChanged<String?> onChanged;

  ClientTypeList({required this.selectedClientType, required this.onChanged});

  @override
  _ClientTypeListState createState() => _ClientTypeListState();
}

class _ClientTypeListState extends State<ClientTypeList> {
  final List<ClientType> tariffsList = [
    ClientType( name: "Юр.Лицо" ),
    ClientType( name: "Физ.Лицо" ),
    ClientType( name: "Ин.Предприниматель" ),
  ];

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> dropdownItems = tariffsList.map<DropdownMenuItem<String>>((ClientType tariff) {
      return DropdownMenuItem<String>(
        value: tariff.name,
        child: Text(
          tariff.name,
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

    if (tariffsList.length == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged(tariffsList.first.name);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text( 'Тип клиента',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Gilroy',
            color: Color(0xff1E2E52),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          child: DropdownButtonFormField<String>(
            value: dropdownItems.any((item) => item.value == widget.selectedClientType)
                ? widget.selectedClientType
                : null,
            hint: Text( 'Выберете тип клиента',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gilroy',
                color: Color(0xff1E2E52),
              ),
            ),
            items: dropdownItems,
            onChanged: widget.onChanged,
            validator: (value) {
              if (value == null) {
                return'Поле обязательно для заполнения';
              }
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFF4F7FD),
              labelStyle: TextStyle(
                color: Colors.grey,
                fontFamily: 'Gilroy',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF4F7FD)),
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF4F7FD)),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF4F7FD)),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              errorStyle: TextStyle(
                fontSize: 14,
                color: Colors.red,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gilroy',
              ),
            ),
            dropdownColor: Colors.white,
            icon: Image.asset(
              'assets/icons/dropdown.png',
              width: 16,
              height: 16,
            ),
          ),
        ),
      ],
    );
  }
}