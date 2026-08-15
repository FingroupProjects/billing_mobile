import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/custom_widget/filter/filter_ui.dart';
import 'package:billing_mobile/models/tariff_model.dart';
import 'package:flutter/material.dart';

class ServiceList extends StatefulWidget {
  final String? selectedService;
  final ValueChanged<String?> onChanged;

  const ServiceList({
    super.key,
    required this.selectedService,
    required this.onChanged,
  });

  @override
  State<ServiceList> createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  List<TariffCatalogItem> _services = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final services = await ApiService().getTariffCatalog();
      if (!mounted) return;
      setState(() {
        _services = services;
        _isLoading = false;
        _error = services.isEmpty ? 'Список услуг пуст' : null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Ошибка загрузки услуг';
      });
    }
  }

  String get _selectedName {
    if (widget.selectedService == null) return '';
    for (final service in _services) {
      if (service.id.toString() == widget.selectedService) {
        return service.name;
      }
    }
    return '';
  }

  Future<void> _openPicker() async {
    if (_isLoading) return;

    if (_error != null || _services.isEmpty) {
      await _loadServices();
      if (!mounted || _services.isEmpty) return;
    }

    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _ServicePickerSheet(
          services: _services,
          selectedId: widget.selectedService,
        );
      },
    );

    if (selected != null) {
      widget.onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedName = _selectedName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Услуга',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            fontFamily: 'Gilroy',
            color: kFilterTextColor,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _openPicker,
          child: InputDecorator(
            decoration: buildFilterDropdownDecoration().copyWith(
              suffixIcon: Padding(
                padding: const EdgeInsets.all(16),
                child: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: kFilterTextColor,
                        ),
                      )
                    : Image.asset(
                        'assets/icons/dropdown.png',
                        width: 16,
                        height: 16,
                      ),
              ),
            ),
            child: Text(
              _error ??
                  (selectedName.isNotEmpty ? selectedName : 'Выберите услугу'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gilroy',
                color: _error != null ? Colors.red : kFilterTextColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ServicePickerSheet extends StatefulWidget {
  final List<TariffCatalogItem> services;
  final String? selectedId;

  const _ServicePickerSheet({
    required this.services,
    required this.selectedId,
  });

  @override
  State<_ServicePickerSheet> createState() => _ServicePickerSheetState();
}

class _ServicePickerSheetState extends State<_ServicePickerSheet> {
  late final TextEditingController _searchController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TariffCatalogItem> get _filteredServices {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return widget.services;
    return widget.services
        .where((service) => service.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredServices;
    final height = MediaQuery.of(context).size.height * 0.7;

    return SafeArea(
      child: SizedBox(
        height: height,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE8ECF5),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Услуга',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Gilroy',
                    color: kFilterTextColor,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                decoration: buildFilterDropdownDecoration().copyWith(
                  hintText: 'Поиск',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Gilroy',
                    color: kFilterTextColor,
                  ),
                ),
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text(
                        'Ничего не найдено',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gilroy',
                          color: Color(0xff99A4BA),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final service = filtered[index];
                        final isSelected =
                            service.id.toString() == widget.selectedId;
                        return ListTile(
                          title: Text(
                            service.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              fontFamily: 'Gilroy',
                              color: kFilterTextColor,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: kFilterActionColor,
                                )
                              : null,
                          onTap: () =>
                              Navigator.pop(context, service.id.toString()),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
