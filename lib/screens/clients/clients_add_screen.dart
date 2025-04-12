
// import 'package:billing_mobile/custom_widget/custom_button.dart';
// import 'package:billing_mobile/custom_widget/custom_phone_number_input.dart';
// import 'package:billing_mobile/custom_widget/custom_textfield.dart';
// import 'package:billing_mobile/widgets/snackbar_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';

// class LeadAddScreen extends StatefulWidget {
//   final int statusId;

//   LeadAddScreen({required this.statusId});

//   @override
//   _LeadAddScreenState createState() => _LeadAddScreenState();
// }

// class _LeadAddScreenState extends State<LeadAddScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController instaLoginController = TextEditingController();
//   final TextEditingController facebookLoginController = TextEditingController();
//   final TextEditingController tgNickController = TextEditingController();
//   final TextEditingController whatsappController = TextEditingController();
//   final TextEditingController birthdayController = TextEditingController();
//   final TextEditingController createDateController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController authorController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();

//   String? selectedRegion;
//   String? selectedManager;
//   String? selectedSourceLead;
//   String selectedDialCode = '';
//   String selectedDialCodeWhatsapp = '';
//   List<CustomField> customFields = [];
//   bool isEndDateInvalid = false;

//   @override
//   void initState() {
//     super.initState();

//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Transform.translate(
//           offset: const Offset(-10, 0),
//           child: const Text(
//             'Новый клиент',
//             style: TextStyle(
//               fontSize: 20,
//               fontFamily: 'Gilroy',
//               fontWeight: FontWeight.w600,
//               color: Color(0xff1E2E52),
//             ),
//           ),
//         ),
//         centerTitle: false,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 0),
//           child: Transform.translate(
//             offset: const Offset(0, -2),
//             child: IconButton(
//               icon: Image.asset(
//                 'assets/icons/arrow-left.png',
//                 width: 24,
//                 height: 24,
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//                 // context.read<LeadBloc>().add(FetchLeadStatuses());
//               },
//             ),
//           ),
//         ),
//         leadingWidth: 40,
//         backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//       ),
//       body: BlocListener<LeadBloc, LeadState>(
//         listener: (context, state) {
//           if (state is LeadError) {
//              showCustomSnackBar(
//                context: context,
//                message: state.message,
//                isSuccess: false,
//              );
//           } else if (state is LeadSuccess) {
//               showCustomSnackBar(
//                context: context,
//                message: state.message,
//                isSuccess: true,
//              );
//             Navigator.pop(context);
//             // context.read<LeadBloc>().add(FetchLeadStatuses());
//           }
//         },
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
//                     FocusScope.of(context).unfocus();
//                   },
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomTextField(
//                           controller: titleController,
//                           hintText: 'Введите  ФИО',
//                           label: 'ФИО',
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Поле обезательно для заполнения!';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 15),
//                         CustomPhoneNumberInput(
//                           controller: phoneController,
//                           onInputChanged: (String number) {
//                             setState(() {
//                               selectedDialCode = number;
//                             });
//                           },
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Поле обезательно для заполнения!';
//                             }
//                             return null;
//                           },
//                           label: 'Телефон',
//                         ),
//                         const SizedBox(height: 15),
//                         CustomTextField(
//                           controller: emailController,
//                           hintText: 'Введите email',
//                           label: 'Email',
//                           keyboardType: TextInputType.emailAddress,
//                         ),
//                         const SizedBox(height: 15),
//                         CustomTextField(
//                           controller: instaLoginController,
//                           hintText: 'Введите контактного лица',
//                           label: 'Контактное лицо',
//                         ),
//                         const SizedBox(height: 15),
//                         CustomTextField(
//                           controller: facebookLoginController,
//                           hintText: 'Введите поддомен',
//                           label: 'Поддомен',
//                         ),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: CustomButton(
//                         buttonText: 'Отмена',
//                         buttonColor: Color(0xffF4F7FD),
//                         textColor: Colors.black,
//                         onPressed: () {
//                           Navigator.pop(context, widget.statusId);
//                           // context.read<LeadBloc>().add(FetchLeadStatuses());
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: BlocBuilder<LeadBloc, LeadState>(
//                         builder: (context, state) {
//                           if (state is LeadLoading) {
//                             return Center(
//                               child: CircularProgressIndicator(
//                                 color: Color(0xff1E2E52),
//                               ),
//                             );
//                           } else {
//                             return CustomButton(
//                               buttonText: 'Добавить',
//                               buttonColor: Color(0xff4759FF),
//                               textColor: Colors.white,
//                               onPressed: _submitForm,
//                             );
//                           }
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       _createLead();
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             AppLocalizations.of(context)!.translate('fill_required_fields'),
//             style: TextStyle(
//               fontFamily: 'Gilroy',
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: Colors.white,
//             ),
//           ),
//           behavior: SnackBarBehavior.floating,
//           margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           backgroundColor: Colors.red,
//           elevation: 3,
//           padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }
//   }

//   void _createLead() {
//     final String name = titleController.text;
//     final String phone = selectedDialCode;
//     final String? instaLogin =
//         instaLoginController.text.isEmpty ? null : instaLoginController.text;
//     final String? facebookLogin = facebookLoginController.text.isEmpty
//         ? null
//         : facebookLoginController.text;
//     final String? tgNick =
//         tgNickController.text.isEmpty ? null : tgNickController.text;
//     final String? whatsapp =
//         whatsappController.text.isEmpty || selectedDialCodeWhatsapp.isEmpty
//             ? null
//             : selectedDialCodeWhatsapp;
//     final String? birthdayString =
//         birthdayController.text.isEmpty ? null : birthdayController.text;
//     final String? email =
//         emailController.text.isEmpty ? null : emailController.text;
//     final String? description =
//         descriptionController.text.isEmpty ? null : descriptionController.text;

//     DateTime? birthday;
//     if (birthdayString != null && birthdayString.isNotEmpty) {
//       try {
//         birthday = DateFormat('dd/MM/yyyy').parse(birthdayString);
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               AppLocalizations.of(context)!.translate('enter_valid_birth_date'),
//               style: TextStyle(
//                 fontFamily: 'Gilroy',
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.white,
//               ),
//             ),
//             behavior: SnackBarBehavior.floating,
//             margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             backgroundColor: Colors.red,
//             elevation: 3,
//             padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//             duration: Duration(seconds: 3),
//           ),
//         );
//         return;
//       }
//     }

//     List<Map<String, String>> customFieldMap = [];
//     for (var field in customFields) {
//       String fieldName = field.fieldName.trim();
//       String fieldValue = field.controller.text.trim();
//       if (fieldName.isNotEmpty && fieldValue.isNotEmpty) {
//         customFieldMap.add({fieldName: fieldValue});
//       }
//     }

//     final localizations = AppLocalizations.of(context)!;

//     // Определяем, является ли выбранный менеджер "Системой"
//     bool isSystemManager = selectedManager == "-1";

//     context.read<LeadBloc>().add(CreateLead(
//       name: name,
//       leadStatusId: widget.statusId,
//       phone: phone,
//       regionId: selectedRegion != null ? int.parse(selectedRegion!) : null,
//       managerId: !isSystemManager && selectedManager != null
//           ? int.parse(selectedManager!)
//           : null,
//       sourceId: selectedSourceLead != null
//           ? int.parse(selectedSourceLead!)
//           : null,
//       instaLogin: instaLogin,
//       facebookLogin: facebookLogin,
//       tgNick: tgNick,
//       waPhone: whatsapp,
//       birthday: birthday,
//       email: email,
//       description: description,
//       customFields: customFieldMap,
//       localizations: localizations,
//       isSystemManager: isSystemManager, // Добавляем флаг для "Системы"
//     ));
//   }
// }

// class CustomField {
//   final String fieldName;
//   final TextEditingController controller = TextEditingController();

//   CustomField({required this.fieldName});
// }