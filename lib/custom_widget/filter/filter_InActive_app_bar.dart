import 'package:billing_mobile/custom_widget/filter/connectionType_list.dart';
import 'package:billing_mobile/screens/clients/client_details/country_list.dart';
import 'package:billing_mobile/screens/clients/client_details/currency_list.dart';
import 'package:billing_mobile/screens/clients/client_details/partner_list.dart';
import 'package:billing_mobile/screens/clients/client_details/tariff_list.dart';
import 'package:flutter/material.dart';
import 'package:billing_mobile/bloc/tariff/tariff_bloc.dart';
import 'package:billing_mobile/bloc/tariff/tariff_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:billing_mobile/api/api_service.dart';

class FilterInActiveScreen extends StatefulWidget {
  final Function(Map<String, dynamic>)? onFilterSelected;
  final Map<String, dynamic>? initialFilters;

  FilterInActiveScreen({
    Key? key,
    this.onFilterSelected,
    this.initialFilters,
  }) : super(key: key);

  @override
  _FilterInActiveScreenState createState() => _FilterInActiveScreenState();
}

class _FilterInActiveScreenState extends State<FilterInActiveScreen> {
  int? _selectedConnectionType;
  int? _selectedTariff;
  int? _selectedPartner;
  int? _selectedCountryId;
  int? _selectedCurrencyId;



  @override
  void initState() {
    super.initState();
    if (widget.initialFilters != null) {
      _selectedConnectionType = widget.initialFilters!['demo'];
      _selectedTariff = widget.initialFilters!['tariff'];
      _selectedPartner = widget.initialFilters!['partner'];
      _selectedCountryId = widget.initialFilters!['country_id'];
      _selectedCurrencyId = widget.initialFilters!['currency_id'];
    }
  }

  void _resetFilters() {
    setState(() {
      _selectedConnectionType = null;
      _selectedTariff = null;
      _selectedPartner = null;
        _selectedCountryId = null;
      _selectedCurrencyId = null;
    });
  }

  @override
   Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TariffBloc(apiService: ApiService())..add(const LoadTariffEvent('992')),
      child: Scaffold(
        backgroundColor: Color(0xffF4F7FD),
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text(
          'Фильтр',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xff1E2E52),
            fontFamily: 'Gilroy',
          ),
        ),
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        elevation: 0,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Transform.translate(
            offset: const Offset(0, -2),
            child: IconButton(
              icon: Image.asset(
                'assets/icons/arrow-left.png',
                width: 24,
                height: 24,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _resetFilters();
              widget.onFilterSelected?.call({});
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              backgroundColor: Colors.blueAccent.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: const BorderSide(color: Colors.blueAccent, width: 0.5),
            ),
            child: const Text(
              'Сбросить',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueAccent,
                fontFamily: 'Gilroy',
              ),
            ),
          ),
          const SizedBox(width: 10),
          TextButton(
            onPressed: () {
              if (_selectedConnectionType == null &&
                  _selectedTariff == null &&
                  _selectedPartner == null&&
                  _selectedCountryId == null&&
                  _selectedCurrencyId == null) {
                Navigator.pop(context);
              } else {
                final filterData = {
                  'demo': _selectedConnectionType,
                  'tariff': _selectedTariff,
                  'partner': _selectedPartner,
                  'country_id': _selectedCountryId,
                  'currency_id': _selectedCurrencyId,
                };
                widget.onFilterSelected?.call(filterData);
                Navigator.pop(context);
              }
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              backgroundColor: Colors.blueAccent.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: const BorderSide(color: Colors.blueAccent, width: 0.5),
            ),
            child: const Text(
              'Применить',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueAccent,
                fontFamily: 'Gilroy',
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ConnectionTypeList(
                          selectedstatus: _selectedConnectionType?.toString(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedConnectionType = newValue != null ? int.parse(newValue) : null;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TariffList(
                          selectedTariff: _selectedTariff?.toString(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedTariff = newValue != null ? int.parse(newValue) : null;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: PartnerList(
                          selectedPartner: _selectedPartner?.toString(),
                          onChanged: (value) {
                            setState(() {
                              _selectedPartner = value != null ? int.parse(value.toString()) : null;
                            });
                          },
                        ),
                      ),
                    ),
                     const SizedBox(height: 8),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: CountryList(
                          selectedCountry: _selectedCountryId?.toString(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCountryId = value != null ? int.parse(value.toString()) : null;
                            });
                          },
                        ),
                      ),
                    ),
                      const SizedBox(height: 8),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: CurrencyList(
                          selectedCurrency: _selectedCurrencyId?.toString(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCurrencyId = value != null ? int.parse(value.toString()) : null;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
       ),
      ),
    );
  }
}