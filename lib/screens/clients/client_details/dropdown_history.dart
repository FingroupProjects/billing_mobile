import 'dart:convert';
import 'package:billing_mobile/bloc/client_history/client_history_bloc.dart';
import 'package:billing_mobile/bloc/client_history/client_history_event.dart';
import 'package:billing_mobile/bloc/client_history/client_history_state.dart';
import 'package:billing_mobile/models/client_history_model.dart';
import 'package:billing_mobile/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ClientHistoryWidget extends StatefulWidget {
  final int clientId;

  ClientHistoryWidget({required this.clientId});

  @override
  _ClientHistoryWidgetState createState() => _ClientHistoryWidgetState();
}

class _ClientHistoryWidgetState extends State<ClientHistoryWidget> {
  bool isActionHistoryExpanded = false;
  List<History> actionHistory = [];

  final Map<String, String> keyTranslations = {
    'name': 'Название',
    'sale': 'Скидки',
    'email': 'Почта',
    'phone': 'Телефон',
    'tariff': 'Тариф',
    'country': 'Страна',
    'client_type': 'Тип клиента',
    'contact_person': 'Контактное лицо',
    'is_active': 'Активность',
    'reject_cause': 'Причина отказа',
  };

  @override
  void initState() {
    super.initState();
    context.read<ClientHistoryBloc>().add(FetchClientHistory(widget.clientId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientHistoryBloc, ClientHistoryState>(
      builder: (context, state) {
        if (state is ClientHistoryLoading) {
          // return Center(child: CircularProgressIndicator(color: Color(0xff1E2E52)));
        } else if (state is ClientHistoryLoaded) {
          actionHistory = state.clientHistory;
        } else if (state is ClientHistoryError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showCustomSnackBar(
              context: context,
              message: state.message,
              isSuccess: false,
            );
          });
        }
        return _buildExpandableActionContainer(
          'История действий',
          actionHistory,
          isActionHistoryExpanded,
          () {
            setState(() {
              isActionHistoryExpanded = !isActionHistoryExpanded;
            });
          },
        );
      },
    );
  }

  Widget _buildExpandableActionContainer(
    String title,
    List<History> history,
    bool isExpanded,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 8),
        decoration: BoxDecoration(
          color: Color(0xFFF4F7FD),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleRow(title),
            SizedBox(height: 8),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: isExpanded
                  ? SizedBox(
                      height: 250,
                      child: SingleChildScrollView(
                        child: _buildItemList(history),
                      ),
                    )
                  : SizedBox.shrink(),
            ),
          ],
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
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w500,
            color: Color(0xff1E2E52),
          ),
        ),
        Image.asset(
          'assets/icons/dropdown.png',
          width: 16,
          height: 16,
        ),
      ],
    );
  }

  Column _buildItemList(List<History> history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: history.map((entry) {
        return _buildActionItem(entry);
      }).toList(),
    );
  }

  Widget _buildActionItem(History entry) {
    final formattedDate = DateFormat('dd.MM.yyyy HH:mm').format(entry.createdAt.toLocal());
    final status = entry.status;
    final userName = entry.user.name;

    List<String> additionalDetails = [];
    for (var change in entry.changes) {
      if (change.body.isNotEmpty && change.body != '[]') {
        try {
          final decodedBody = jsonDecode(change.body) as Map<String, dynamic>;
          decodedBody.forEach((key, value) {
            final newValue = value['new_value'] ?? 'Не указано';
            final previousValue = value['previous_value'] ?? 'Не указано';
            additionalDetails.add('$key: $previousValue > $newValue');
          });
        } catch (e) {
          additionalDetails.add('Ошибка парсинга изменений');
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusRow(status, '$userName, $formattedDate'),
          SizedBox(height: 10),
          if (additionalDetails.isNotEmpty) _buildAdditionalDetails(additionalDetails),
        ],
      ),
    );
  }

  Row _buildStatusRow(String status, String userName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            status,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
              color: Color(0xff1E2E52),
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 2,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            userName,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
              color: Color(0xff1E2E52),
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  Column _buildAdditionalDetails(List<String> details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: details.where((detail) => detail.isNotEmpty).map((detail) {
        final parts = detail.split(': ');
        final key = parts[0];
        final value = parts.length > 1 ? parts[1] : '';
        final translatedKey = keyTranslations[key] ?? key;

        return Padding(
          padding: const EdgeInsets.only(left: 8, top: 4),
          child: RichText(
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$translatedKey: ',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w400,
                    color: Color(0x801E2E52),
                  ),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w400,
                    color: Color(0xff1E2E52), 
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}