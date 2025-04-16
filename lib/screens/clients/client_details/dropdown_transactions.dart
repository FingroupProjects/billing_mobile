import 'package:billing_mobile/bloc/transactions/transactions_bloc.dart';
import 'package:billing_mobile/bloc/transactions/transactions_event.dart';
import 'package:billing_mobile/bloc/transactions/transactions_state.dart';
import 'package:billing_mobile/custom_widget/custom_card_tasks_tabBar.dart';
import 'package:billing_mobile/models/transactions_model.dart';
import 'package:billing_mobile/screens/clients/client_details/transactions_screen/transaction_details_screen.dart';
import 'package:billing_mobile/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionsWidget extends StatefulWidget {
  final int clientId;


  TransactionsWidget({Key? key, required this.clientId, })
      : super(key: key);

  @override
  _TransactionsWidgetState createState() => _TransactionsWidgetState();
}

class _TransactionsWidgetState extends State<TransactionsWidget> {

  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(FetchTransactionEvent(widget.clientId.toString()));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        List<Transaction> transactions = [];
        if (state is TransactionLoading) {
        } else if (state is TransactionLoaded) {
          transactions = state.transactions;
        } else if (state is TransactionError) {
          print(state.message);
          WidgetsBinding.instance.addPostFrameCallback((_) {
           showCustomSnackBar(
             context: context,
             message: state.message,
             isSuccess: false,
           );
          });
        }

        return _buildTransactionsList(transactions);
      },
    );
  }

  Widget _buildTransactionsList(List<Transaction> transactions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleRow('Транзакции'),
        const SizedBox(height: 4),
        if (transactions.isEmpty)
          _buildEmptyState()
        else
          Container(
            height: 400,
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return _buildTransactionItem(transactions[index]);
              },
            ),
          ),
      ],
    );
  }
   Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: TaskCardStyles.taskCardDecoration,
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: 0),
                Text( 'Нет транзакции',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1E2E52),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Widget _buildTransactionItem(Transaction transaction) {
  final createdAt = DateFormat('dd.MM.yyyy HH:mm').format(transaction.createdAt);
  final isIncome = transaction.type == "Пополнение";
  final typeText = isIncome ? "Пополнение" : "Снятие";
  final typeColor = isIncome ? Colors.green : Colors.red;

  return GestureDetector(
    // onTap: () => _showDetailsTransactionScreen(transaction),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffF4F7FD),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: typeColor,
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 4, left: 12, right: 12, bottom: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                  color: typeColor,
                  size: 16,
                ),
              ),
             const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text( typeText,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w500,
                            color: typeColor,
                          ),
                        ),
                        Text( transaction.sum,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w500,
                            color: typeColor,
                          ),
                        ),
                      ],
                    ),
                    Text( 'Дата: $createdAt',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Gilroy',
                        color: Color(0xff1E2E52),
                      ),
                    ),
                    Text( 'Организация: ${transaction.organization?.name ?? ''}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Gilroy',
                        color: Color(0xff1E2E52),
                      ),
                    ),
                    Text( 'Тариф: ${transaction.tariff?.name.toString() ?? ''}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Gilroy',
                        color: Color(0xff1E2E52),
                      ),
                    ),
                    Text( 'Скидка: ${transaction.sale?.amount.toString() ?? '' }',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Gilroy',
                        color: Color(0xff1E2E52),
                      ),
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Row _buildTitleRow(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            color: Color(0xff1E2E52),
          ),
        ),
          // TextButton(
          //   onPressed: _showAddOrganizationScreen,
          //   style: TextButton.styleFrom(
          //     foregroundColor: Colors.white,
          //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //     backgroundColor: Color(0xff1E2E52),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //   ),
          //   child: const Text(
          //     'Добавить',
          //     style: TextStyle(
          //       fontSize: 16,
          //       fontFamily: 'Gilroy',
          //       fontWeight: FontWeight.w500,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
      ],
    );
  }


// void _showAddOrganizationScreen() async {
//   final result = await Navigator.push<bool>(
//     context,
//     MaterialPageRoute(
//       builder: (context) => CreateOrganizationScreen(clientId: widget.clientId),
//     ),
//   );

//   if (result == true) {
//     context.read<OrganizationBloc>().add(
//       FetchOrganizationEvent(widget.clientId.toString()),
//     );
//   }
// }


void _showDetailsTransactionScreen(Transaction transaction) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TransactionDetailsScreen(
        transactionId: transaction.id, 
      ),
    ),
  );
}
  // void _showEditOrganizationDialog(Organization organization) {
  //   // Navigator.push(
  //   //   context,
  //   //   MaterialPageRoute(
  //   //     builder: (context) => OrganizationDetailsScreen(
  //   //       organizationId: organization.id,
  //   //     ),
  //   //   ),
  //   // );
  // }

  // void _showDeleteOrganizationDialog(Organization organization) {
  //   // showDialog(
  //   //   context: context,
  //   //   builder: (BuildContext context) {
  //   //     return DeleteOrganizationDialog(
  //   //       organization: organization, 
  //   //       clientId: widget.clientId,
  //   //     );
  //   //   },
  //   // );
  // }
}