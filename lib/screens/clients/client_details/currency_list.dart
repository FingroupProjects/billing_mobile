import 'package:billing_mobile/bloc/currency/currency_bloc.dart';
import 'package:billing_mobile/bloc/currency/currency_event.dart';
import 'package:billing_mobile/bloc/currency/currency_state.dart';
import 'package:billing_mobile/custom_widget/filter/filter_ui.dart';
import 'package:billing_mobile/models/currency_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyList extends StatefulWidget {
  final String? selectedCurrency;
  final ValueChanged<String?> onChanged;

  const CurrencyList({required this.selectedCurrency, required this.onChanged});

  @override
  _CurrencyListState createState() => _CurrencyListState();
}

class _CurrencyListState extends State<CurrencyList> {
  @override
  void initState() {
    super.initState();
    context.read<CurrencyBloc>().add(LoadCurrencyEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, state) {
        List<CurrencyData> currenciesList = [];

        if (state is CurrencyLoadedState) {
          currenciesList = state.currencies;
        } else if (state is CurrencyErrorState) {
          return const Text('Ошибка загрузки валют!');
        }

        List<DropdownMenuItem<String>> dropdownItems = currenciesList.map<DropdownMenuItem<String>>((CurrencyData currency) {
          return DropdownMenuItem<String>(
            value: currency.id.toString(),
            child: Text(
              '${currency.name}',
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

        if (currenciesList.length == 1) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onChanged(currenciesList.first.id.toString());
          });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Валюта',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gilroy',
                color: kFilterTextColor,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: dropdownItems.any((item) => item.value == widget.selectedCurrency)
                  ? widget.selectedCurrency
                  : null,
              hint: const Text(
                'Выберите валюту',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Gilroy',
                  color: kFilterTextColor,
                ),
              ),
              items: dropdownItems,
              onChanged: widget.onChanged,
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
