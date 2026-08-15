import 'package:billing_mobile/custom_widget/filter/filter_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterDateField extends StatefulWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onChanged;

  const FilterDateField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onChanged,
  });

  @override
  State<FilterDateField> createState() => _FilterDateFieldState();
}

class _FilterDateFieldState extends State<FilterDateField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _format(widget.selectedDate));
  }

  @override
  void didUpdateWidget(FilterDateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _controller.text = _format(widget.selectedDate);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _format(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> _selectDate() async {
    final formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? DateTime.now(),
      fieldHintText: 'ддммгггг',
      cancelText: 'Назад',
      confirmText: 'Ок',
      helpText: 'Выберете дату',
      errorFormatText: '${'Пример: '}$formattedDate',
      errorInvalidText: 'неправильный формат',
      fieldLabelText: 'Введите дату',
      firstDate: DateTime(1940),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            hintColor: Colors.blue,
            colorScheme: const ColorScheme.light(primary: Color(0xff1E2E52)),
            dialogBackgroundColor: Colors.white,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (pickedDate != null) {
      widget.onChanged(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            fontFamily: 'Gilroy',
            color: kFilterTextColor,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _selectDate,
          child: AbsorbPointer(
            child: TextFormField(
              controller: _controller,
              decoration: buildFilterDropdownDecoration().copyWith(
                hintText: 'дд/мм/гггг',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Gilroy',
                  color: kFilterTextColor,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    'assets/icons/date.png',
                    width: 18,
                    height: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
