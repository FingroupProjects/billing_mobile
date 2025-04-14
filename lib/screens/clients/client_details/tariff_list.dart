import 'package:flutter/material.dart';

class Tariff {
  final int id;
  final String name;

  Tariff({required this.id, required this.name});
}

class TariffList extends StatefulWidget {
  final String? selectedTariff;
  final ValueChanged<String?> onChanged;

  TariffList({required this.selectedTariff, required this.onChanged});

  @override
  _TariffListState createState() => _TariffListState();
}

class _TariffListState extends State<TariffList> {
  final List<Tariff> tariffsList = [
    Tariff( id: 1, name: "Standart" ),
    Tariff( id: 2, name: "Тариф" ),
    Tariff( id: 3, name: "Тариф премиум" ),
  ];

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> dropdownItems = tariffsList.map<DropdownMenuItem<String>>((Tariff tariff) {
      return DropdownMenuItem<String>(
        value: tariff.id.toString(),
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
        widget.onChanged(tariffsList.first.id.toString());
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text( 'Тариф',
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
            value: dropdownItems.any((item) => item.value == widget.selectedTariff)
                ? widget.selectedTariff
                : null,
            hint: Text( 'Выберете тариф',
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