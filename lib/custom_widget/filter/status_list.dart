import 'package:flutter/material.dart';

class StatusData {
  final int id;
  final String name;

  StatusData({required this.id, required this.name});
}

class StatusList extends StatefulWidget {
  final String? selectedstatus;
  final ValueChanged<String?> onChanged;

  StatusList({required this.selectedstatus, required this.onChanged});

  @override
  _StatusListState createState() => _StatusListState();
}

class _StatusListState extends State<StatusList> {
  final List<StatusData> statussList = [
    StatusData( id: 1, name: "Активынй" ),
    StatusData( id: 0, name: "Неактивынй" ),
  ];

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> dropdownItems = statussList.map<DropdownMenuItem<String>>((StatusData status) {
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

    if (statussList.length == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged(statussList.first.id.toString());
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text( 'Статус',
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
            value: dropdownItems.any((item) => item.value == widget.selectedstatus)
                ? widget.selectedstatus
                : null,
            hint: Text( 'Выберете статус',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gilroy',
                color: Color(0xff1E2E52),
              ),
            ),
            items: dropdownItems,
            onChanged: widget.onChanged,
            // validator: (value) {
            //   if (value == null) {
            //     return'Поле обязательно для заполнения';
            //   }
            //   return null;
            // },
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