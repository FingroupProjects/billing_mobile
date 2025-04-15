import 'package:billing_mobile/bloc/BusinessType/BusinessType_bloc.dart';
import 'package:billing_mobile/bloc/businessType/businessType_event.dart';
import 'package:billing_mobile/bloc/businessType/businessType_state.dart';
import 'package:billing_mobile/models/businessType_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BusinessType {
  final int id;
  final String name;

  BusinessType({
    required this.id,
    required this.name,

  });
}

class BusinessTypeList extends StatefulWidget {
  final String? selectedBusinessType;
  final ValueChanged<String?> onChanged;

  BusinessTypeList({required this.selectedBusinessType, required this.onChanged});

  @override
  _BusinessTypeListState createState() => _BusinessTypeListState();
}

class _BusinessTypeListState extends State<BusinessTypeList> {
  @override
  void initState() {
    super.initState();
    context.read<BusinessTypeBloc>().add(LoadBusinessTypeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessTypeBloc, BusinessTypeState>(
      builder: (context, state) {
        List<BusinessTypeData> BusnessTypeList = [];
        
        if (state is BusinessTypeLoadedState) {
          BusnessTypeList = state.businessTypes;
        } else if (state is BusinessTypeErrorState) {
          return Text('Ошибка загрузки тип бизнеса!');
        }

        List<DropdownMenuItem<String>> dropdownItems = BusnessTypeList.map<DropdownMenuItem<String>>((BusinessTypeData BusinessType) {
          return DropdownMenuItem<String>(
            value: BusinessType.id.toString(),
            child: Text(
              '${BusinessType.name}' ,
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Тип бизнеса',
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
                value: dropdownItems.any((item) => item.value == widget.selectedBusinessType)
                    ? widget.selectedBusinessType
                    : null,
                hint: const Text(
                  'Выберите тип бизнеса',
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