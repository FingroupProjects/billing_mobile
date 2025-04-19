import 'package:billing_mobile/custom_widget/filter/connectionType_list.dart';
import 'package:billing_mobile/custom_widget/filter/status_list.dart';
import 'package:billing_mobile/screens/clients/client_details/partner_list.dart';
import 'package:billing_mobile/screens/clients/client_details/tariff_list.dart';
import 'package:flutter/material.dart';

class FilterClientScreen extends StatefulWidget {
  final Function(Map<String, dynamic>)? onFilterSelected;
  final Map<String, dynamic>? initialFilters;

  FilterClientScreen({
    Key? key,
    this.onFilterSelected,
    this.initialFilters,
  }) : super(key: key);

  @override
  _FilterClientScreenState createState() => _FilterClientScreenState();
}

class _FilterClientScreenState extends State<FilterClientScreen> {
  int? _selectedConnectionType;
  int? _selectedStatus;
  int? _selectedTariff;
  int? _selectedPartner;

  @override
  void initState() {
    super.initState();
    if (widget.initialFilters != null) {
      _selectedConnectionType = widget.initialFilters!['demo'];
      _selectedStatus = widget.initialFilters!['status'];
      _selectedTariff = widget.initialFilters!['tariff'];
      _selectedPartner = widget.initialFilters!['partner'];
    }
  }

  void _resetFilters() {
    setState(() {
      _selectedConnectionType = null;
      _selectedStatus = null;
      _selectedTariff = null;
      _selectedPartner = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  _selectedStatus == null &&
                  _selectedTariff == null &&
                  _selectedPartner == null) {
                Navigator.pop(context);
              } else {
                final filterData = {
                  'demo': _selectedConnectionType,
                  'status': _selectedStatus,
                  'tariff': _selectedTariff,
                  'partner': _selectedPartner,
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
                        child: StatusList(
                          selectedstatus: _selectedStatus?.toString(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedStatus = newValue != null ? int.parse(newValue) : null;
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}