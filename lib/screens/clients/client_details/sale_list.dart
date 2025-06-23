import 'package:billing_mobile/bloc/sale/sale_event.dart';
import 'package:billing_mobile/models/sale_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:billing_mobile/bloc/sale/sale_bloc.dart';
import 'package:billing_mobile/bloc/sale/sale_state.dart';

class Sale {
  final int id;
  final String name;
  final String saleType;
  final String amount;
  final int active;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Sale({
    required this.id,
    required this.name,
    required this.saleType,
    required this.amount,
    required this.active,
    this.createdAt,
    this.updatedAt,
  });
}

class SaleList extends StatefulWidget {
  final String? selectedSale;
  final ValueChanged<String?> onChanged;

  const SaleList({required this.selectedSale, required this.onChanged, super.key});

  @override
  _SaleListState createState() => _SaleListState();
}

class _SaleListState extends State<SaleList> {
  @override
  void initState() {
    super.initState();
    context.read<SaleBloc>().add(LoadSaleEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SaleBloc, SaleState>(
      builder: (context, state) {
        List<SaleData> salesList = [];

        if (state is SaleLoadingState) {
          // return const Center(child: CircularProgressIndicator());
        } else if (state is SaleLoadedState) {
          salesList = state.sales;
          if (salesList.isEmpty) {
            return const Text(
              'Скидки не найдены',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gilroy',
                color: Color(0xff1E2E52),
              ),
            );
          }
        } else if (state is SaleErrorState) {
          return Text(
            'Ошибка загрузки скидок: ${state.message}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Gilroy',
              color: Colors.red,
            ),
          );
        }

        List<DropdownMenuItem<String>> dropdownItems = salesList.map<DropdownMenuItem<String>>((SaleData sale) {
          return DropdownMenuItem<String>(
            value: sale.id.toString(),
            child: Text(
              '${sale.name} (${sale.saleType == 'procent' ? '${sale.amount}%' : '${sale.amount} сумма'})',
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

        if (salesList.length == 1) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onChanged(salesList.first.id.toString());
          });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Скидка',
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
                value: dropdownItems.any((item) => item.value == widget.selectedSale)
                    ? widget.selectedSale
                    : null,
                hint: const Text(
                  'Выберите скидку',
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
                  if (value == null && salesList.isNotEmpty) {
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