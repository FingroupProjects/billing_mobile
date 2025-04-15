import 'package:billing_mobile/bloc/organizations/organizations_bloc.dart';
import 'package:billing_mobile/bloc/organizations/organizations_state.dart';
import 'package:billing_mobile/custom_widget/custom_button.dart';
import 'package:billing_mobile/custom_widget/custom_phone_number_input.dart';
import 'package:billing_mobile/custom_widget/custom_textfield.dart';
import 'package:billing_mobile/models/organizations_model.dart';
import 'package:billing_mobile/screens/clients/client_details/organizations_screen/businessType_list.dart';
import 'package:billing_mobile/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditOrganizationScreen extends StatefulWidget {
  final int clientId;
  final Organization organization; 

  const EditOrganizationScreen({
    required this.clientId,
    required this.organization,
  });

  @override
  _EditOrganizationScreenState createState() => _EditOrganizationScreenState();
}

class _EditOrganizationScreenState extends State<EditOrganizationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController innController;
  late TextEditingController addressController;

  String? selectedDialCode;
  String? selectedTypeBuisness;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.organization.name);
    phoneController = TextEditingController(text: widget.organization.phone);
    innController = TextEditingController(text: widget.organization.INN.toString());
    addressController = TextEditingController(text: widget.organization.address);
    selectedDialCode = widget.organization.phone;
    selectedTypeBuisness = widget.organization.businessTypeId.toString();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    innController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Transform.translate(
          offset: const Offset(-10, 0),
          child: const Text(
            'Редактировать организацию',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
              color: Color(0xff1E2E52),
            ),
          ),
        ),
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
        leadingWidth: 40,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocListener<OrganizationBloc, OrganizationState>(
              listener: (context, state) {
                if (state is OrganizationUpdateError) {
                  showCustomSnackBar(
                    context: context,
                    message: state.message,
                    isSuccess: false,
                  );
                } else if (state is OrganizationUpdated) {
                  showCustomSnackBar(
                    context: context,
                    message: 'Организация успешно обновлена!',
                    isSuccess: true,
                  );
                  Navigator.pop(context);
                }
              },
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 80),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: nameController,
                          hintText: 'Введите название',
                          label: 'Наименование',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Поле обязательно для заполнения';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        CustomPhoneNumberInput(
                          controller: phoneController,
                          onInputChanged: (String number) {
                            setState(() {
                              selectedDialCode = number;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Поле обязательно для заполнения!';
                            }
                            return null;
                          },
                          label: 'Телефон',
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: innController,
                          hintText: 'Введите ИНН',
                          label: 'ИНН',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Поле обязательно для заполнения';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        BusinessTypeList(
                          selectedBusinessType: selectedTypeBuisness ?? '',
                          onChanged: (value) {
                            setState(() {
                              selectedTypeBuisness = value;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: addressController,
                          hintText: 'Введите адрес',
                          label: 'Адрес',
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Поле обязательно для заполнения';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    buttonText: 'Отмена',
                    buttonColor: const Color(0xffF4F7FD),
                    textColor: Colors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: BlocBuilder<OrganizationBloc, OrganizationState>(
                    builder: (context, state) {
                      if (state is OrganizationLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: Color(0xff1E2E52)),
                        );
                      } else {
                        return CustomButton(
                          buttonText: 'Сохранить',
                          buttonColor: const Color(0xff4759FF),
                          textColor: Colors.white,
                          onPressed: _submitForm,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // context.read<OrganizationBloc>().add(UpdateOrganization(
      //   id: widget.organization.id, 
      //   name: nameController.text,
      //   phone: selectedDialCode ?? phoneController.text,
      //   inn: innController.text,
      //   businessTypeId: selectedTypeBuisness ?? '',
      //   address: addressController.text,
      // ));
    } else {
      showCustomSnackBar(
        context: context,
        message: 'Заполните все обязательные поля!',
        isSuccess: false,
      );
    }
  }
}