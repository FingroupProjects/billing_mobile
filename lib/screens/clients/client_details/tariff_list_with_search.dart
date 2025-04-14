// import 'package:animated_custom_dropdown/custom_dropdown.dart';
// import 'package:flutter/material.dart';
// import 'package:billing_mobile/models/clients_model.dart';

// class TariffListWidget extends StatefulWidget {
//   final int? selectedTariffId;
//   final Function(Tariff) onSelectTariff;

//   TariffListWidget({
//     super.key, 
//     required this.onSelectTariff, 
//     this.selectedTariffId,
//   });

//   @override
//   State<TariffListWidget> createState() => _TariffListWidgetState();
// }

// class _TariffListWidgetState extends State<TariffListWidget> {
//   final List<Tariff> tariffsList = [
//     Tariff(
//       id: 1,
//       name: "Standart",
//     ),
//     Tariff(
//       id: 2,
//       name: "Тариф",
//     ),
//     Tariff(
//       id: 3,
//       name: "Тариф премиум",
//     ),
//   ];

//   Tariff? selectedTariff;

//   @override
//   void initState() {
//     super.initState();
//     // Set initial selected tariff if provided
//     if (widget.selectedTariffId != null) {
//       selectedTariff = tariffsList.firstWhere(
//         (tariff) => tariff.id == widget.selectedTariffId,
//         orElse: () => tariffsList.first,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Тариф',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             fontFamily: 'Gilroy',
//             color: Color(0xff1E2E52),
//           ),
//         ),
//         const SizedBox(height: 4),
//         Container(
//           child: CustomDropdown<Tariff>.search(
//             closeDropDownOnClearFilterSearch: true,
//             items: tariffsList,
//             searchHintText: 'Поиск',
//             overlayHeight: 400,
//             enabled: true,
//             decoration: CustomDropdownDecoration(
//               closedFillColor: Color(0xffF4F7FD),
//               expandedFillColor: Colors.white,
//               closedBorder: Border.all(
//                 color: Color(0xffF4F7FD),
//                 width: 1,
//               ),
//               closedBorderRadius: BorderRadius.circular(12),
//               expandedBorder: Border.all(
//                 color: Color(0xffF4F7FD),
//                 width: 1,
//               ),
//               expandedBorderRadius: BorderRadius.circular(12),
//             ),
//             listItemBuilder: (context, item, isSelected, onItemSelect) {
//               return Text(
//                 item.name,
//                 style: TextStyle(
//                   color: Color(0xff1E2E52),
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   fontFamily: 'Gilroy',
//                 ),
//               );
//             },
//             headerBuilder: (context, selectedItem, enabled) {
//               return Text(
//                 selectedItem?.name ?? 'Выберите тариф',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   fontFamily: 'Gilroy',
//                   color: Color(0xff1E2E52),
//                 ),
//               );
//             },
//             hintBuilder: (context, hint, enabled) => Text(
//               'Выберите тариф',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 fontFamily: 'Gilroy',
//                 color: Color(0xff1E2E52),
//               ),
//             ),
//             excludeSelected: false,
//             initialItem: selectedTariff,
//             validator: (value) {
//               if (value == null) {
//                 return 'Поле обязательно для заполнения';
//               }
//               return null;
//             },
//             onChanged: (value) {
//               if (value != null) {
//                 widget.onSelectTariff(value);
//                 setState(() {
//                   selectedTariff = value;
//                 });
//                 FocusScope.of(context).unfocus();
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

//                // TariffListWidget(
//                         //   selectedTariffId: selectedTariff,
//                         //   onSelectTariff: (Tariff selectedTariffData) {
//                         //     setState(() {
//                         //       selectedTariff = selectedTariffData.id;
//                         //     });
//                         //   },
//                         // ),