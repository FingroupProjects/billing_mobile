import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/transactions/transactions_bloc.dart';
import 'package:billing_mobile/bloc/transactions/transactions_event.dart';
import 'package:billing_mobile/bloc/transactions/transactions_state.dart';
import 'package:billing_mobile/custom_widget/custom_card_tasks_tabBar.dart';
import 'package:billing_mobile/models/transactions_model.dart';
import 'package:billing_mobile/screens/clients/client_details/transactions_screen/add_transaction.dart';
import 'package:billing_mobile/screens/clients/client_details/transactions_screen/transaction_details_screen.dart';
import 'package:billing_mobile/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionsWidget extends StatefulWidget {
  final int clientId;

  const TransactionsWidget({Key? key, required this.clientId}) : super(key: key);

  @override
  _TransactionsWidgetState createState() => _TransactionsWidgetState();
}

class _TransactionsWidgetState extends State<TransactionsWidget> {
  late ScrollController _scrollController;
  String _filterType = 'All';
  final ApiService _apiService = ApiService(); // Добавляем ApiService

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<TransactionBloc>().add(FetchTransactionEvent(widget.clientId.toString()));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = context.read<TransactionBloc>().state;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
      (state is TransactionLoaded && !state.isLoadingMore)) {
      context.read<TransactionBloc>().add(FetchMoreTransactionsEvent(widget.clientId.toString()));
    }
  }

  void _toggleFilter() {
    setState(() {
      if (_filterType == 'All') {
        _filterType = 'Income';
      } else if (_filterType == 'Income') {
        _filterType = 'Withdrawal';
      } else {
        _filterType = 'All';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        TransactionListResponse? transactionData;
        bool isLoadingMore = false;

        if (state is TransactionLoading) {
          // return const Center(child: CircularProgressIndicator(color: Color(0xff1E2E52)));
        } else if (state is TransactionLoaded) {
          transactionData = state.transactionData;
          isLoadingMore = state.isLoadingMore;
        } else if (state is TransactionError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showCustomSnackBar(
              context: context,
              message: state.message,
              isSuccess: false,
            );
          });
        }

        return _buildTransactionsList(transactionData, isLoadingMore);
      },
    );
  }

Widget _buildTransactionsList(TransactionListResponse? transactionData, bool isLoadingMore) {
    final transactions = transactionData?.data.data ?? [];
 
     final filteredTransactions = transactions.where((transaction) {
      if (_filterType == 'All') return true;
      if (_filterType == 'Income') return transaction.type == "Пополнение";
      if (_filterType == 'Withdrawal') return transaction.type == "Снятие";
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleRow('Транзакции'),
        const SizedBox(height: 4),
        if (filteredTransactions.isEmpty)
          _buildEmptyState()
        else
          Container(
            height: 400,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: filteredTransactions.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < filteredTransactions.length) {
                  return _buildTransactionItem(filteredTransactions[index]);
                } else {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(color: Color(0xff1E2E52)),
                    ),
                  );
                }
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
  final createdAt = DateFormat('dd.MM.yyyy HH:mm').format(transaction.createdAt.toLocal());
  final isIncome = transaction.type == "credit";
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
        Row(
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
            const SizedBox(width: 12),
            IconButton(
              icon: Icon(
                _filterType == 'All'
                    ? Icons.filter_list
                    : _filterType == 'Income'
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                color: Color(0xff1E2E52),
                size: 30,
              ),
              onPressed: _toggleFilter,
              tooltip: 'Фильтр транзакций',
            ),
          ],
        ),
        FutureBuilder<bool>(
          future: _apiService.isAdmin(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            }
            final isAdmin = snapshot.data ?? false;
            return isAdmin
                ? TextButton(
                    onPressed: _showAddOrganizationScreen,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      backgroundColor: Color(0xff1E2E52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Пополнить баланс',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }


void _showAddOrganizationScreen() async {
  final result = await Navigator.push<bool>(
    context,
    MaterialPageRoute(
      builder: (context) => CreateTransactionScreen(clientId: widget.clientId),
    ),
  );

  if (result == true) {
    context.read<TransactionBloc>().add(
      FetchTransactionEvent(widget.clientId.toString()),
    );
  }
}


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