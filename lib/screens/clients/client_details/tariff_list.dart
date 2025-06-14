import 'package:billing_mobile/bloc/tariff/tariff_bloc.dart';
import 'package:billing_mobile/bloc/tariff/tariff_event.dart';
import 'package:billing_mobile/bloc/tariff/tariff_state.dart';
import 'package:billing_mobile/models/tariff_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TariffList extends StatefulWidget {
  final String? selectedTariff;
  final ValueChanged<String?> onChanged;

  const TariffList({required this.selectedTariff, required this.onChanged});

  @override
  _TariffListState createState() => _TariffListState();
}

class _TariffListState extends State<TariffList> {
  @override
  void initState() {
    super.initState();
    // Trigger tariff loading if not already loaded
    final tariffBloc = context.read<TariffBloc>();
    if (tariffBloc.state is TariffInitialState) {
      tariffBloc.add(const LoadTariffEvent('992')); // Default code
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TariffBloc, TariffState>(
      builder: (context, state) {
        print('TariffList state: $state'); // Debug log
        List<TariffData> tariffsList = [];

        if (state is TariffLoadedState) {
          tariffsList = state.tariffs;
          print('Tariffs loaded: ${tariffsList.length}'); // Debug log
        } else if (state is TariffErrorState) {
          print('Tariff error: ${state.message}'); // Debug log
          return const Text('Ошибка загрузки тарифов!');
        } else if (state is TariffLoadingState) {
          // return const CircularProgressIndicator(); // Show loading indicator
        }

        List<DropdownMenuItem<String>> dropdownItems = tariffsList.map<DropdownMenuItem<String>>((TariffData tariffData) {
          return DropdownMenuItem<String>(
            value: tariffData.id.toString(),
            child: Text(
              '${tariffData.tariff.name} (\$${tariffData.tariffPrice})',
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
            const Text(
              'Тариф',
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
                isExpanded: true, // Ensure dropdown items are fully visible
                value: dropdownItems.any((item) => item.value == widget.selectedTariff)
                    ? widget.selectedTariff
                    : null,
                hint: const Text(
                  'Выберите тариф',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Gilroy',
                    color: Color(0xff1E2E52),
                  ),
                ),
                items: dropdownItems.isNotEmpty
                    ? dropdownItems
                    : [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text(
                  'Выберите тариф',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Gilroy',
                    color: Color(0xff1E2E52),
                  ),
                ),
                        ),
                      ], // Fallback item
                onChanged: tariffsList.isNotEmpty ? widget.onChanged : null, // Disable if no tariffs
                validator: (value) {
                  if (value == null) {
                    return 'Поле обязательно для заполнения';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF4F7FD),
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Gilroy',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFF4F7FD)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFF4F7FD)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFF4F7FD)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorStyle: const TextStyle(
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
      },
    );
  }
}