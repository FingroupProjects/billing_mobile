import 'package:billing_mobile/bloc/country/country_event.dart';
import 'package:billing_mobile/bloc/country/country_state.dart';
import 'package:billing_mobile/models/Country_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:billing_mobile/bloc/Country/Country_bloc.dart';

class Country {
  final int id;
  final String name;

  Country({
    required this.id,
    required this.name,

  });
}

class CountryList extends StatefulWidget {
  final String? selectedCountry;
  final ValueChanged<String?> onChanged;

  CountryList({required this.selectedCountry, required this.onChanged});

  @override
  _CountryListState createState() => _CountryListState();
}

class _CountryListState extends State<CountryList> {
  @override
  void initState() {
    super.initState();
    context.read<CountryBloc>().add(LoadCountryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountryBloc, CountryState>(
      builder: (context, state) {
        List<CountryData> CountrysList = [];
        
        if (state is CountryLoadedState) {
          CountrysList = state.countries;
        } else if (state is CountryErrorState) {
          return Text('Ошибка загрузки скидок!');
        }

        List<DropdownMenuItem<String>> dropdownItems = CountrysList.map<DropdownMenuItem<String>>((CountryData Country) {
          return DropdownMenuItem<String>(
            value: Country.id.toString(),
            child: Text(
              '${Country.name}' ,
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

        if (CountrysList.length == 1) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onChanged(CountrysList.first.id.toString());
          });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Страна',
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
                value: dropdownItems.any((item) => item.value == widget.selectedCountry)
                    ? widget.selectedCountry
                    : null,
                hint: const Text(
                  'Выберите страну',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Gilroy',
                    color: Color(0xff1E2E52),
                  ),
                ),
                items: dropdownItems,
                onChanged: widget.onChanged,
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