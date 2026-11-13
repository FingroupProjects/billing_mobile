import 'package:billing_mobile/custom_widget/filter/filter_date_range_field.dart';
import 'package:billing_mobile/custom_widget/filter/filter_ui.dart';
import 'package:billing_mobile/custom_widget/filter/status_list.dart';
import 'package:billing_mobile/screens/clients/client_details/country_list.dart';
import 'package:billing_mobile/screens/clients/client_details/partner_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterDemoScreen extends StatefulWidget {
  final Function(Map<String, dynamic>)? onFilterSelected;
  final Map<String, dynamic>? initialFilters;

  const FilterDemoScreen({
    super.key,
    this.onFilterSelected,
    this.initialFilters,
  });

  @override
  State<FilterDemoScreen> createState() => _FilterDemoScreenState();
}

class _FilterDemoScreenState extends State<FilterDemoScreen> {
  int? _selectedStatus;
  int? _selectedPartner;
  int? _selectedCountry;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  DateTime? _createdFrom;
  DateTime? _createdTo;

  @override
  void initState() {
    super.initState();
    if (widget.initialFilters != null) {
      _selectedStatus = widget.initialFilters!['status'];
      _selectedPartner = widget.initialFilters!['partner'];
      _selectedCountry = widget.initialFilters!['country'];
      _dateFrom = _parseApiDate(widget.initialFilters!['date_from']);
      _dateTo = _parseApiDate(widget.initialFilters!['date_to']);
      _createdFrom = _parseApiDate(widget.initialFilters!['create_at_from']);
      _createdTo = _parseApiDate(widget.initialFilters!['create_at_to']);
    }
  }

  DateTime? _parseApiDate(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty || text == 'null') return null;
    return DateTime.tryParse(text);
  }

  String? _formatApiDate(DateTime? date) {
    if (date == null) return null;
    return DateFormat('yyyy-MM-dd').format(date);
  }

  bool get _hasSelectedFilters =>
      _selectedStatus != null ||
      _selectedPartner != null ||
      _selectedCountry != null ||
      _dateFrom != null ||
      _dateTo != null ||
      _createdFrom != null ||
      _createdTo != null;

  void _resetFilters() {
    setState(() {
      _selectedStatus = null;
      _selectedPartner = null;
      _selectedCountry = null;
      _dateFrom = null;
      _dateTo = null;
      _createdFrom = null;
      _createdTo = null;
    });
    widget.onFilterSelected?.call({});
  }

  void _applyFilters() {
    if (!_hasSelectedFilters) {
      Navigator.pop(context);
      return;
    }

    widget.onFilterSelected?.call({
      'status': _selectedStatus,
      'partner': _selectedPartner,
      'country': _selectedCountry,
      if (_dateFrom != null) 'date_from': _formatApiDate(_dateFrom),
      if (_dateTo != null) 'date_to': _formatApiDate(_dateTo),
      if (_createdFrom != null) 'create_at_from': _formatApiDate(_createdFrom),
      if (_createdTo != null) 'create_at_to': _formatApiDate(_createdTo),
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kFilterBackgroundColor,
      appBar: AppBar(
        backgroundColor: kFilterBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 40,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Image.asset(
            'assets/icons/arrow-left.png',
            width: 24,
            height: 24,
          ),
        ),
        title: Row(
          children: [
            const Expanded(
              child: Text(
                'Фильтр',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: kFilterTextColor,
                  fontFamily: 'Gilroy',
                ),
              ),
            ),
            FilterActionButton(title: 'Сбросить', onPressed: _resetFilters),
            const SizedBox(width: 12),
            FilterActionButton(title: 'Применить', onPressed: _applyFilters),
            const SizedBox(width: 12),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            children: [
              FilterSectionCard(
                child: StatusList(
                  selectedstatus: _selectedStatus?.toString(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedStatus =
                          newValue == null ? null : int.parse(newValue);
                    });
                  },
                ),
              ),
              const SizedBox(height: 18),
              FilterSectionCard(
                child: PartnerList(
                  selectedPartner: _selectedPartner?.toString(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPartner =
                          value != null ? int.parse(value) : null;
                    });
                  },
                ),
              ),
              const SizedBox(height: 18),
              FilterSectionCard(
                child: CountryList(
                  selectedCountry: _selectedCountry?.toString(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCountry =
                          value != null ? int.parse(value) : null;
                    });
                  },
                ),
              ),
              const SizedBox(height: 18),
              FilterSectionCard(
                child: FilterDateRangeField(
                  label: 'Срок действия',
                  startDate: _dateFrom,
                  endDate: _dateTo,
                  onChanged: (range) {
                    setState(() {
                      _dateFrom = range?.start;
                      _dateTo = range?.end;
                    });
                  },
                ),
              ),
              const SizedBox(height: 18),
              FilterSectionCard(
                child: FilterDateRangeField(
                  label: 'Дата создания',
                  startDate: _createdFrom,
                  endDate: _createdTo,
                  onChanged: (range) {
                    setState(() {
                      _createdFrom = range?.start;
                      _createdTo = range?.end;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
