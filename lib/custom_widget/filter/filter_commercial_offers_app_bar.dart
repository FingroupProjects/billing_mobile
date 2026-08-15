import 'package:billing_mobile/custom_widget/filter/filter_date_field.dart';
import 'package:billing_mobile/custom_widget/filter/filter_ui.dart';
import 'package:billing_mobile/custom_widget/filter/operation_status_list.dart';
import 'package:billing_mobile/custom_widget/filter/period_months_list.dart';
import 'package:billing_mobile/custom_widget/filter/request_type_list.dart';
import 'package:billing_mobile/custom_widget/filter/service_list.dart';
import 'package:billing_mobile/screens/clients/client_details/partner_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterCommercialOffersScreen extends StatefulWidget {
  final Function(Map<String, dynamic>)? onFilterSelected;
  final Map<String, dynamic>? initialFilters;

  const FilterCommercialOffersScreen({
    super.key,
    this.onFilterSelected,
    this.initialFilters,
  });

  @override
  State<FilterCommercialOffersScreen> createState() =>
      _FilterCommercialOffersScreenState();
}

class _FilterCommercialOffersScreenState
    extends State<FilterCommercialOffersScreen> {
  int? _selectedPartner;
  String? _selectedRequestType;
  int? _selectedTariff;
  int? _selectedPeriodMonths;
  String? _selectedOperationStatus;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  @override
  void initState() {
    super.initState();
    final filters = widget.initialFilters;
    if (filters != null) {
      _selectedPartner = _readInt(filters['partner_id']);
      _selectedRequestType = _readString(filters['request_type']);
      _selectedTariff = _readInt(filters['tariff_id']);
      _selectedPeriodMonths = _readInt(filters['period_months']);
      _selectedOperationStatus = _readString(filters['operation_status']);
      _dateFrom = _parseApiDate(filters['date_from']);
      _dateTo = _parseApiDate(filters['date_to']);
    }
  }

  int? _readInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString().trim());
  }

  String? _readString(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty || text == 'null') return null;
    return text;
  }

  DateTime? _parseApiDate(dynamic value) {
    final text = _readString(value);
    if (text == null) return null;
    return DateTime.tryParse(text);
  }

  String? _formatApiDate(DateTime? date) {
    if (date == null) return null;
    return DateFormat('yyyy-MM-dd').format(date);
  }

  bool get _hasSelectedFilters =>
      _selectedPartner != null ||
      _selectedRequestType != null ||
      _selectedTariff != null ||
      _selectedPeriodMonths != null ||
      _selectedOperationStatus != null ||
      _dateFrom != null ||
      _dateTo != null;

  void _resetFilters() {
    setState(() {
      _selectedPartner = null;
      _selectedRequestType = null;
      _selectedTariff = null;
      _selectedPeriodMonths = null;
      _selectedOperationStatus = null;
      _dateFrom = null;
      _dateTo = null;
    });
    widget.onFilterSelected?.call({});
  }

  void _applyFilters() {
    if (!_hasSelectedFilters) {
      Navigator.pop(context);
      return;
    }

    final filters = <String, dynamic>{
      if (_selectedPartner != null) 'partner_id': _selectedPartner,
      if (_selectedRequestType != null) 'request_type': _selectedRequestType,
      if (_selectedTariff != null) 'tariff_id': _selectedTariff,
      if (_selectedPeriodMonths != null) 'period_months': _selectedPeriodMonths,
      if (_selectedOperationStatus != null)
        'operation_status': _selectedOperationStatus,
      if (_dateFrom != null) 'date_from': _formatApiDate(_dateFrom),
      if (_dateTo != null) 'date_to': _formatApiDate(_dateTo),
    };
    widget.onFilterSelected?.call(filters);
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
                child: PartnerList(
                  selectedPartner: _selectedPartner?.toString(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPartner = _readInt(value);
                    });
                  },
                ),
              ),
              const SizedBox(height: 18),
              FilterSectionCard(
                child: RequestTypeList(
                  selectedRequestType: _selectedRequestType,
                  onChanged: (value) {
                    setState(() {
                      _selectedRequestType = _readString(value);
                    });
                  },
                ),
              ),
              const SizedBox(height: 18),
              FilterSectionCard(
                child: ServiceList(
                  selectedService: _selectedTariff?.toString(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTariff = _readInt(value);
                    });
                  },
                ),
              ),
              const SizedBox(height: 18),
              FilterSectionCard(
                child: PeriodMonthsList(
                  selectedPeriod: _selectedPeriodMonths?.toString(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPeriodMonths = _readInt(value);
                    });
                  },
                ),
              ),
              const SizedBox(height: 18),
              FilterSectionCard(
                child: OperationStatusList(
                  selectedStatus: _selectedOperationStatus,
                  onChanged: (value) {
                    setState(() {
                      _selectedOperationStatus = _readString(value);
                    });
                  },
                ),
              ),
              const SizedBox(height: 18),
              FilterSectionCard(
                child: FilterDateField(
                  label: 'Дата от',
                  selectedDate: _dateFrom,
                  onChanged: (value) {
                    setState(() {
                      _dateFrom = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 18),
              FilterSectionCard(
                child: FilterDateField(
                  label: 'Дата до',
                  selectedDate: _dateTo,
                  onChanged: (value) {
                    setState(() {
                      _dateTo = value;
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
