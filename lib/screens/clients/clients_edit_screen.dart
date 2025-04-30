import 'package:billing_mobile/bloc/clients/clients_bloc.dart';
import 'package:billing_mobile/bloc/clients/clients_event.dart';
import 'package:billing_mobile/bloc/clients/clients_state.dart';
import 'package:billing_mobile/custom_widget/custom_button.dart';
import 'package:billing_mobile/custom_widget/custom_phone_number_input.dart';
import 'package:billing_mobile/custom_widget/custom_textfield.dart';
import 'package:billing_mobile/screens/clients/client_details/client_type_list.dart';
import 'package:billing_mobile/screens/clients/client_details/country_list.dart';
import 'package:billing_mobile/screens/clients/client_details/partner_list.dart';
import 'package:billing_mobile/screens/clients/client_details/sale_list.dart';
import 'package:billing_mobile/screens/clients/client_details/tariff_list.dart';
import 'package:billing_mobile/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Client {
  final String id;
  final String fio;
  final String phone;
  final String email;
  final String? contactPerson;
  final String subDomain;
  final int? partnerId;
  final String? clientType;
  final int? tariffId;
  final int? saleId;
  final int? countryId;
  final bool isDemo;

  Client({
    required this.id,
    required this.fio,
    required this.phone,
    required this.email,
    this.contactPerson,
    required this.subDomain,
    this.partnerId,
    this.clientType,
    this.tariffId,
    this.saleId,
    this.countryId,
    required this.isDemo,
  });
}

class ClientEditScreen extends StatefulWidget {
  final String clientId;
  final String fio;
  final String phone;
  final String email;
  final String? contactPerson;
  final String subDomain;
  final int? partnerId;
  final String? clientType;
  final int? tariffId;
  final int? saleId;
  final int? countryId;
  final bool isDemo;

  ClientEditScreen({Key? key,     
    required this.clientId,
    required this.fio,
    required this.phone,
    required this.email,
    this.contactPerson,
    required this.subDomain,
    this.partnerId,
    this.clientType,
    this.tariffId,
    this.saleId,
    this.countryId,
    required this.isDemo,
     }) : super(key: key);

  @override
  _ClientEditScreenState createState() => _ClientEditScreenState();
}

class _ClientEditScreenState extends State<ClientEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController fioController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController contactPersonLoginController;
  late TextEditingController subdomainController;

  int? selectedPartner;
  String? selectedClientType;
  int? selectedTariff;
  String selectedDialCode = '';
  int? selectedSaleId;
  int? selectedCountryId;
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    fioController = TextEditingController(text: widget.fio);
    phoneController = TextEditingController(text: widget.phone);
    emailController = TextEditingController(text: widget.email);
    contactPersonLoginController = TextEditingController(text: widget.contactPerson);
    subdomainController = TextEditingController(text: widget.subDomain);

    selectedPartner = widget.partnerId;
    selectedClientType = widget.clientType;
    selectedTariff = widget.tariffId;
    selectedDialCode = widget.phone; 
    selectedSaleId = widget.saleId;
    selectedCountryId = widget.countryId;
    isActive = widget.isDemo;
  }

  @override
  void dispose() {
    fioController.dispose();
    phoneController.dispose();
    emailController.dispose();
    contactPersonLoginController.dispose();
    subdomainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Transform.translate(
          offset: const Offset(-10, 0),
          child: const Text(
            'Редактирование клиента',
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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: BlocListener<ClientBloc, ClientState>(
        listener: (context, state) {
          if (state is ClientError) {
            showCustomSnackBar(
              context: context,
              message: state.message,
              isSuccess: false,
            );
          } else if (state is ClientSuccess) {
            showCustomSnackBar(
              context: context,
              message: state.message,
              isSuccess: true,
            );
            Navigator.pop(context);
            context.read<ClientBloc>().add(FetchClients());
          }
        },
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          controller: fioController,
                          hintText: 'Введите ФИО',
                          label: 'ФИО',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Поле обязательно для заполнения!';
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
                          controller: emailController,
                          hintText: 'Введите email',
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Поле обязательно для заполнения!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: contactPersonLoginController,
                          hintText: 'Введите контактное лицо',
                          label: 'Контактное лицо',
                        ),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: subdomainController,
                          hintText: 'Введите поддомен',
                          label: 'Поддомен',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Поле обязательно для заполнения!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        PartnerList(
                          selectedPartner: selectedPartner?.toString(),
                          onChanged: (value) {
                            setState(() {
                              selectedPartner = int.parse(value.toString());
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        ClientTypeList(
                          selectedClientType: selectedClientType,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedClientType = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        TariffList(
                          selectedTariff: selectedTariff?.toString(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedTariff = newValue != null ? int.parse(newValue) : null;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        SaleList(
                          selectedSale: selectedSaleId?.toString(),
                          onChanged: (value) {
                            setState(() {
                              selectedSaleId = int.parse(value.toString());
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        CountryList(
                          selectedCountry: selectedCountryId?.toString(),
                          onChanged: (value) {
                            setState(() {
                              selectedCountryId = int.parse(value.toString());
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isActive = !isActive;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF4F7FD),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Демо версия',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Gilroy',
                                              color: isActive
                                                  ? const Color(0xFF1E1E1E)
                                                  : const Color(0xFF1E1E1E).withOpacity(0.3),
                                            ),
                                          ),
                                          Switch(
                                            value: isActive,
                                            onChanged: (value) {
                                              setState(() {
                                                isActive = value;
                                              });
                                            },
                                            activeColor: const Color.fromARGB(255, 255, 255, 255),
                                            inactiveTrackColor: const Color.fromARGB(255, 179, 179, 179).withOpacity(0.5),
                                            activeTrackColor: const Color(0xff4759FF),
                                            inactiveThumbColor: const Color.fromARGB(255, 255, 255, 255),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
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
                      child: BlocBuilder<ClientBloc, ClientState>(
                        builder: (context, state) {
                          if (state is ClientLoading) {
                            return const Center(child: CircularProgressIndicator(color: Color(0xff1E2E52)));
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
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _updateClient();
    } else {
      showCustomSnackBar(
        context: context,
        message: 'Заполните все обязательные поля!',
        isSuccess: false,
      );
    }
  }

  void _updateClient() {
    // final String fio = fioController.text;
    // final String phone = selectedDialCode;
    // final String email = emailController.text;
    // final String? contactPerson = contactPersonLoginController.text.isEmpty ? null : contactPersonLoginController.text;
    // final String subDomain = subdomainController.text;

    // context.read<ClientBloc>().add(UpdateClient(
    //   id: widget.client.id,
    //   fio: fio,
    //   phone: phone,
    //   email: email,
    //   contactPerson: contactPerson,
    //   subDomain: subDomain,
    //   partnerId: selectedPartner,
    //   clientType: selectedClientType,
    //   tariffId: selectedTariff,
    //   saleId: selectedSaleId,
    //   countryId: selectedCountryId,
    //   isDemo: isActive,
    // ));
  }
}