import 'package:billing_mobile/bloc/clients_by_id/clientById_bloc.dart';
import 'package:billing_mobile/bloc/clients_by_id/clientById_event.dart';
import 'package:billing_mobile/bloc/clients_by_id/clientById_state.dart';
import 'package:billing_mobile/models/clientsById_model.dart';
import 'package:billing_mobile/screens/clients/client_details/dropdown_transactions.dart';
import 'package:billing_mobile/screens/clients/client_details/organizations_screen/organization_delete.dart';
import 'package:billing_mobile/screens/clients/client_details/dropdown_organizations.dart';
import 'package:billing_mobile/screens/clients/clients_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ClientDetailsScreen extends StatefulWidget {
  final int clientId;

  const ClientDetailsScreen({
    Key? key,
    required this.clientId,
  }) : super(key: key);

  @override
  _ClientDetailsScreenState createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends State<ClientDetailsScreen> {
  ClientById? currentClient;
  late ScrollController _scrollController;
  List<Map<String, String>> details = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    context.read<ClientByIdBloc>().add(FetchClientByIdEvent(clientId: widget.clientId.toString()));
  }

  void _updateDetails(ClientById client, List<Sale> sales, String expirationDate) {

  Sale? clientSale;
  if (client.saleId != null) {
    clientSale = sales.firstWhere(
      (sale) => sale.id == client.saleId,
    );
  }

    String formattedExpirationDate = '';
  if (expirationDate.isNotEmpty) {
    try {
      final parsedDate = DateTime.parse(expirationDate);
      formattedExpirationDate = DateFormat('dd.MM.yyyy').format(parsedDate);
    } catch (e) {
      formattedExpirationDate = 'Неверный формат даты';
    }
  }

  setState(() {
    currentClient = client;
    details = [
      {'label': 'ФИО:', 'value': client.name},
      {'label': 'Телефон:', 'value': client.phone},
      {'label': 'Почта:', 'value': client.email ?? ''},
      {'label': 'Поддомен:', 'value': client.subDomain},
      {'label': 'Тип клиента:', 'value': client.clientType},
      {'label': 'Тариф:', 'value': client.tariff.name},
      {'label': 'Контактное лицо:', 'value': client.contactPerson ?? ''},
      {'label': 'Партнер ID:', 'value': client.partnerId?.toString() ?? ''},
      {'label': 'Страна:', 'value': client.countryId?.toString() ?? ''},
      {'label': 'Скидка:', 'value': client.saleId != null  ? '${clientSale?.name}' : '' },
      {'label': 'Дата создания:', 'value': DateFormat('dd.MM.yyyy').format(client.createdAt)},
      {'label': 'Дата окончания доступа:', 'value': formattedExpirationDate },
    ];
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context, 'Детали клиента'),
      backgroundColor: Colors.white,
      body: BlocListener<ClientByIdBloc, ClientByIdState>(
        listener: (context, state) {  
          if (state is ClientByIdLoaded) {
         _updateDetails(state.client, state.sales,state.expirationDate); 
          } else if (state is ClientByIdError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ClientByIdBloc, ClientByIdState>(
          builder: (context, state) {
            if (state is ClientByIdLoading) {
              return const Center(child: CircularProgressIndicator(color: Color(0xff1E2E52)));
            } else if (state is ClientByIdLoaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListView(
                  controller: _scrollController,
                  children: [
                    _buildDetailsList(),
                    const SizedBox(height: 8),
                  OrganizationsWidget( clientId: widget.clientId),
                    const SizedBox(height: 8),
                  TransactionsWidget( clientId: widget.clientId),
                    // if (currentClient?.history.isNotEmpty ?? false)
                      // _buildHistorySection(),
                  ],
                ),
              );
            } else if (state is ClientByIdError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Загрузка данных...'));
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, String title) {
    return AppBar(
      backgroundColor: Colors.white,
      forceMaterialTransparency: true,
      centerTitle: false,
      leadingWidth: 40,
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
            onPressed: () async {
              Navigator.pop(context,);
            },
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w600,
          color: Color(0xff1E2E52),
        ),
      ),
      actions: [
        // IconButton(
        //   icon: Image.asset( 'assets/icons/edit.png', width: 24, height: 24 ),
        //   onPressed: () => _navigateToEditScreen(),
        // ),
        // IconButton(
        //   icon: Image.asset( 'assets/icons/delete.png', width: 24, height: 24),          
        //   onPressed: () {
        //    showDialog(
        //      context: context,
        //      builder: (context) => DeleteClientDialog(clientId: currentClient!.id),
        //    );
        //  },        
        // ),
      ],
    );
  }

Widget _buildDetailsList() {
  return Column(
    children: [
      _buildSectionWithTitle(
        title: "Личные данные",
        items: details.take(3).toList(),
      ),
      const Divider(height: 5, thickness: 1, indent: 16, endIndent: 16, color: Color(0xff1E2E52)),
      SizedBox(height: 5),
      
      _buildSectionWithTitle(
        title: "Аккаунт",
        items: details.skip(3).take(11).toList(),
      ),
      const Divider(height: 5, thickness: 1, indent: 16, endIndent: 16, color: Color(0xff1E2E52)),
    
    ],
  );
}

Widget _buildSectionWithTitle({
  required String title,
  required List<Map<String, String>> items,
}) {
  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 18, left: 16, right: 16, bottom: 8), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.map((item) =>
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: _buildDetailItem(item['label']!, item['value']!),
            )
          ).toList(),
        ),
      ),
      Positioned(
        top: 0,
        right: 16,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
             color: Color(0xffF4F7FD),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
              color: Color(0xff1E2E52),
            ),
          ),
        ),
      ),
    ],
  );
}


  Widget _buildDetailItem(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // width: 175,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w500,
              color: Color(0xff99A4BA),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: label == 'Телефон:'
              ? _buildPhoneField(value)
              : Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1E2E52),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildPhoneField(String phone) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _makePhoneCall(phone),
          child: Text(
            phone,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w500,
              color: Color(0xff1E2E52),
              // decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'История изменений',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
                color: Color(0xff1E2E52),
              ),
            ),
            const SizedBox(height: 8),
            ...currentClient!.history.map((entry) => _buildHistoryItem(entry)),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(HistoryEntry entry) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Изменение от ${DateFormat('dd.MM.yyyy').format(entry.createdAt)}',
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
              color: Color(0xff1E2E52),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Пользователь: ${entry.user.name} (${entry.user.role})',
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Gilroy',
              color: Color(0xff99A4BA),
            ),
          ),
          Text(
            'Статус: ${entry.status}',
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Gilroy',
              color: Color(0xff99A4BA),
            ),
          ),
          if (entry.changes.isNotEmpty)
            ...entry.changes.map((change) => Text(
                  change.body,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Gilroy',
                    color: Color(0xff99A4BA),
                  ),
                )),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    // try {
    //   if (await canLaunchUrl(launchUri)) {
    //     await launchUrl(launchUri);
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Не удалось совершить звонок')),
    //     );
    //   }
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Ошибка при звонке: $e')),
    //   );
    // }
  }

  void _navigateToEditScreen() {
    if (currentClient == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientEditScreen(
         clientId: currentClient!.id.toString(),
         fio: currentClient!.name,
         phone: currentClient!.phone,
         email: currentClient!.email.toString(),
         subDomain: currentClient!.subDomain,
         clientType: currentClient!.clientType,
         tariffId: currentClient!.tariffId,
         contactPerson: currentClient!.contactPerson,
         partnerId: currentClient!.partnerId,
         countryId: currentClient!.countryId,
         saleId: currentClient!.saleId,
         isDemo: currentClient!.isDemo,

        ),
      ),
    ).then((shouldRefresh) {
      if (shouldRefresh == true) {
        // context.read<ClientByIdBloc>().add(FetchClientByIdEvent(clientId: widget.clientId));
      }
    });
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удаление клиента'),
        content: const Text('Вы уверены, что хотите удалить этого клиента?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteClient();
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteClient() async {
    if (currentClient == null) return;

  //   try {
  //     await _apiService.deleteClient(currentClient!.id.toString());
  //     Navigator.pop(context, true);
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Ошибка при удалении: $e')),
  //     );
  //   }
  // }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
}