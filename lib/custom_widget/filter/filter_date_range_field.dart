import 'package:billing_mobile/custom_widget/filter/filter_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterDateRangeField extends StatefulWidget {
  final String label;
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTimeRange?> onChanged;

  const FilterDateRangeField({
    super.key,
    required this.label,
    required this.startDate,
    required this.endDate,
    required this.onChanged,
  });

  @override
  State<FilterDateRangeField> createState() => _FilterDateRangeFieldState();
}

class _FilterDateRangeFieldState extends State<FilterDateRangeField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _formatRange());
  }

  @override
  void didUpdateWidget(FilterDateRangeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startDate != widget.startDate ||
        oldWidget.endDate != widget.endDate) {
      _controller.text = _formatRange();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);

  String _formatRange() {
    if (widget.startDate == null && widget.endDate == null) return '';
    if (widget.startDate != null && widget.endDate != null) {
      return '${_formatDate(widget.startDate!)} — ${_formatDate(widget.endDate!)}';
    }
    final date = widget.startDate ?? widget.endDate!;
    return _formatDate(date);
  }

  DateTimeRange? get _currentRange {
    if (widget.startDate == null || widget.endDate == null) return null;
    return DateTimeRange(start: widget.startDate!, end: widget.endDate!);
  }

  static const Color _navy = Color(0xff1E2E52);
  static const Color _muted = Color(0xff99A4BA);
  static const Color _rangeFill = Color(0x1A1E2E52);
  static const Color _divider = Color(0xFFE8ECF5);

  static const TextStyle _gilroy = TextStyle(
    fontFamily: 'Gilroy',
    color: _navy,
  );

  ThemeData _pickerTheme() {
    final baseTextTheme = ThemeData.light().textTheme.apply(
          fontFamily: 'Gilroy',
          bodyColor: _navy,
          displayColor: _navy,
        );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Gilroy',
      scaffoldBackgroundColor: Colors.white,
      canvasColor: Colors.white,
      dialogBackgroundColor: Colors.white,
      textTheme: baseTextTheme,
      primaryTextTheme: baseTextTheme,
      iconTheme: const IconThemeData(color: _navy),
      colorScheme: const ColorScheme.light(
        primary: _navy,
        onPrimary: Colors.white,
        secondary: _navy,
        onSecondary: Colors.white,
        tertiary: _navy,
        surface: Colors.white,
        onSurface: _navy,
        surfaceTint: Colors.transparent,
        primaryContainer: Color(0xFFE8EEF8),
        onPrimaryContainer: _navy,
        secondaryContainer: Color(0xFFE8EEF8),
        onSecondaryContainer: _navy,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: _navy,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: _navy),
        titleTextStyle: TextStyle(
          fontFamily: 'Gilroy',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: _navy,
        ),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        dividerColor: _divider,
        rangePickerBackgroundColor: Colors.white,
        rangePickerSurfaceTintColor: Colors.transparent,
        rangePickerElevation: 0,
        rangePickerShadowColor: Colors.transparent,
        rangePickerHeaderBackgroundColor: Colors.white,
        rangePickerHeaderForegroundColor: _navy,
        rangePickerHeaderHelpStyle: _gilroy.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _muted,
        ),
        rangePickerHeaderHeadlineStyle: _gilroy.copyWith(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
        headerBackgroundColor: Colors.white,
        headerForegroundColor: _navy,
        headerHelpStyle: _gilroy.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _muted,
        ),
        headerHeadlineStyle: _gilroy.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        weekdayStyle: _gilroy.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: _muted,
        ),
        dayStyle: _gilroy.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        yearStyle: _gilroy.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        rangeSelectionBackgroundColor: _rangeFill,
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          if (states.contains(WidgetState.disabled)) return _muted;
          return _navy;
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _navy;
          return Colors.transparent;
        }),
        todayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return _navy;
        }),
        todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _navy;
          return Colors.transparent;
        }),
        todayBorder: const BorderSide(color: _navy, width: 1),
        cancelButtonStyle: TextButton.styleFrom(
          foregroundColor: _muted,
          textStyle: _gilroy.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        confirmButtonStyle: TextButton.styleFrom(
          foregroundColor: _navy,
          textStyle: _gilroy.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final pickedRange = await showDateRangePicker(
      context: context,
      initialDateRange: _currentRange,
      firstDate: DateTime(1940),
      lastDate: DateTime(2101),
      cancelText: 'Назад',
      confirmText: 'Ок',
      helpText: 'Выберите период',
      saveText: 'Ок',
      fieldStartHintText: 'ддммгггг',
      fieldEndHintText: 'ддммгггг',
      fieldStartLabelText: 'Дата от',
      fieldEndLabelText: 'Дата до',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: _pickerTheme(),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (pickedRange != null) {
      widget.onChanged(pickedRange);
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
          onTap: _selectDateRange,
          child: AbsorbPointer(
            child: TextFormField(
              controller: _controller,
              decoration: buildFilterDropdownDecoration().copyWith(
                hintText: 'дд/мм/гггг — дд/мм/гггг',
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
