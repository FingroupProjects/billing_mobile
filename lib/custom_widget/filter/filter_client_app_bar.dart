import 'package:billing_mobile/bloc/tariff/tariff_bloc.dart';
import 'package:billing_mobile/bloc/tariff/tariff_event.dart';
import 'package:billing_mobile/custom_widget/filter/filter_date_range_field.dart';
import 'package:billing_mobile/custom_widget/filter/filter_ui.dart';
import 'package:billing_mobile/screens/clients/client_details/country_list.dart';
import 'package:billing_mobile/screens/clients/client_details/currency_list.dart';
import 'package:billing_mobile/screens/clients/client_details/partner_list.dart';
import 'package:billing_mobile/screens/clients/client_details/tariff_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FilterClientScreen extends StatefulWidget {
  final Function(Map<String, dynamic>)? onFilterSelected;
  final Map<String, dynamic>? initialFilters;

  const FilterClientScreen({
    super.key,
    this.onFilterSelected,
    this.initialFilters,
  });

  @override
  State<FilterClientScreen> createState() => _FilterClientScreenState();
}

class _FilterClientScreenState extends State<FilterClientScreen> {
  int? _selectedTariff;
  int? _selectedPartner;
  int? _selectedCountryId;
  int? _selectedCurrencyId;
  DateTime? _validUntilFrom;
  DateTime? _validUntilTo;

  @override
  void initState() {
    super.initState();
    if (widget.initialFilters != null) {
      _selectedTariff = widget.initialFilters!['tariff'];
      _selectedPartner = widget.initialFilters!['partner'];
      _selectedCountryId = widget.initialFilters!['country_id'];
      _selectedCurrencyId = widget.initialFilters!['currency_id'];
      _validUntilFrom = _parseApiDate(widget.initialFilters!['valid_until_from']);
      _validUntilTo = _parseApiDate(widget.initialFilters!['valid_until_to']);
    }
    context.read<TariffBloc>().add(const LoadTariffEvent('998'));
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
      _selectedTariff != null ||
      _selectedPartner != null ||
      _selectedCountryId != null ||
      _selectedCurrencyId != null ||
      _validUntilFrom != null ||
      _validUntilTo != null;

  void _resetFilters() {
    setState(() {
      _selectedTariff = null;
      _selectedPartner = null;
      _selectedCountryId = null;
      _selectedCurrencyId = null;
      _validUntilFrom = null;
      _validUntilTo = null;
    });
    widget.onFilterSelected?.call({});
  }

  void _applyFilters() {
    if (!_hasSelectedFilters) {
      Navigator.pop(context);
      return;
    }

    widget.onFilterSelected?.call({
      'tariff': _selectedTariff,
      'partner': _selectedPartner,
      'country_id': _selectedCountryId,
      'currency_id': _selectedCurrencyId,
      'valid_until_from': _formatApiDate(_validUntilFrom),
      'valid_until_to': _formatApiDate(_validUntilTo),
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
                child: TariffList(
                  selectedTariff: _selectedTariff?.toString(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedTariff =
                          newValue != null ? int.parse(newValue) : null;
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
                  selectedCountry: _selectedCountryId?.toString(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCountryId =
                          value != null ? int.parse(value) : null;
                    });
                  },
                ),
              ),
              const SizedBox(height: 18),
              FilterSectionCard(
                child: CurrencyList(
                  selectedCurrency: _selectedCurrencyId?.toString(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCurrencyId =
                          value != null ? int.parse(value) : null;
                    });
                  },
                ),
              ),
              const SizedBox(height: 18),
              FilterSectionCard(
                child: FilterDateRangeField(
                  label: 'Срок действия:',
                  startDate: _validUntilFrom,
                  endDate: _validUntilTo,
                  onChanged: (range) {
                    setState(() {
                      _validUntilFrom = range?.start;
                      _validUntilTo = range?.end;
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
