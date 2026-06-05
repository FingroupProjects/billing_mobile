import 'package:billing_mobile/bloc/tariff/tariff_bloc.dart';
import 'package:billing_mobile/bloc/tariff/tariff_event.dart';
import 'package:billing_mobile/bloc/tariff/tariff_state.dart';
import 'package:billing_mobile/custom_widget/filter/filter_ui.dart';
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
      tariffBloc.add(const LoadTariffEvent('998')); // Default code
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TariffBloc, TariffState>(
      builder: (context, state) {
        List<TariffData> tariffsList = [];

        if (state is TariffLoadedState) {
          tariffsList = state.tariffs;
        }

        List<DropdownMenuItem<String>> dropdownItems = tariffsList.map<DropdownMenuItem<String>>((TariffData tariffData) {
          return DropdownMenuItem<String>(
            value: tariffData.tariff.id.toString(),
            child: Text(
              tariffData.tariff.name,
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
            widget.onChanged(tariffsList.first.tariff.id.toString());
          });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Тариф',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gilroy',
                color: kFilterTextColor,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              isExpanded: true,
              value: dropdownItems.any((item) => item.value == widget.selectedTariff)
                  ? widget.selectedTariff
                  : null,
              hint: const Text(
                'Выберите тариф',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Gilroy',
                  color: kFilterTextColor,
                ),
              ),
              items: dropdownItems,
              onChanged: tariffsList.isNotEmpty ? widget.onChanged : null,
              decoration: buildFilterDropdownDecoration(),
              dropdownColor: Colors.white,
              icon: Image.asset(
                'assets/icons/dropdown.png',
                width: 16,
                height: 16,
              ),
            ),
          ],
        );
      },
    );
  }
}
