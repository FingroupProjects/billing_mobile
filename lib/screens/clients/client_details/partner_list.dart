import 'package:billing_mobile/bloc/partners/partners_bloc.dart';
import 'package:billing_mobile/bloc/partners/partners_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:billing_mobile/bloc/partners/partners_event.dart';
import 'package:billing_mobile/models/partner_model.dart';

class PartnerList extends StatefulWidget {
  final String? selectedPartner;
  final ValueChanged<String?> onChanged;

  PartnerList({required this.selectedPartner, required this.onChanged});

  @override
  _PartnerListState createState() => _PartnerListState();
}

class _PartnerListState extends State<PartnerList> {
  @override
  void initState() {
    super.initState();
    context.read<PartnerBloc>().add(LoadPartnerEvent()); 
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartnerBloc, PartnerState>(
      builder: (context, state) {
        if (state is PartnerLoadingState) {
          return _buildLoadingWidget();
        } else if (state is PartnerErrorState) {
          return _buildErrorWidget(state.message);
        } else if (state is PartnerLoadedState) {
          return _buildPartnerDropdown(state.partners);
        } else {
          return _buildInitialWidget();
        }
      },
    );
  }

  Widget _buildInitialWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Партнер',
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
            value: null,
            hint: const Text(
              'Выберите партнера',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gilroy',
                color: Color(0xff1E2E52),
              ),
            ),
            items: [],
            onChanged: null,
            decoration: _inputDecoration(),
            icon: Image.asset(
              'assets/icons/dropdown.png',
              width: 16,
              height: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Партнер',
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
            value: null,
            hint: const Text(
              'Выберите партнера',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gilroy',
                color: Color(0xff1E2E52),
              ),
            ),
            items: [],
            onChanged: null,
            decoration: _inputDecoration(),
            icon: Image.asset(
              'assets/icons/dropdown.png',
              width: 16,
              height: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(String errorMessage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Партнер',
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
            value: null,
            hint: Text(
              'Ошибка: rrorMessage',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gilroy',
                color: Colors.red,
              ),
            ),
            items: [],
            onChanged: null,
            decoration: _inputDecoration(),

          ),
        ),
      ],
    );
  }

  Widget _buildPartnerDropdown(List<Partner> partners) {
    List<DropdownMenuItem<String>> dropdownItems = partners.map<DropdownMenuItem<String>>((Partner partner) {
      return DropdownMenuItem<String>(
        value: partner.id.toString(),
        child: Text(
          partner.name,
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

    // if (partners.length == 1) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     widget.onChanged(partners.first.id.toString());
    //   });
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Партнер',
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
            value: dropdownItems.any((item) => item.value == widget.selectedPartner)
                ? widget.selectedPartner
                : null,
            hint: const Text(
              'Выберите партнера',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Gilroy',
                color: Color(0xff1E2E52),
              ),
            ),
            items: dropdownItems,
            onChanged: widget.onChanged,
            // validator: (value) {
            //   if (value == null) {
            //     return 'Поле обязательно для заполнения';
            //   }
            //   return null;
            // },
            decoration: _inputDecoration(),
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
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
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
    );
  }
}