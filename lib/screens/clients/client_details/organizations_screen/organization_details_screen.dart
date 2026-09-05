import 'package:billing_mobile/bloc/organizationsById/organizationsById_bloc.dart';
import 'package:billing_mobile/bloc/organizationsById/organizationsById_event.dart';
import 'package:billing_mobile/bloc/organizationsById/organizationsById_state.dart';
import 'package:billing_mobile/custom_widget/custom_card_tasks_tabBar.dart';
import 'package:billing_mobile/models/organizations_model.dart';
import 'package:billing_mobile/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

enum BalanceOperationFilter { all, income, outcome }

class OrganizationDetailsScreen extends StatefulWidget {
  final int organizationId;

  const OrganizationDetailsScreen({
    required this.organizationId,
    super.key,
  });

  @override
  State<OrganizationDetailsScreen> createState() =>
      _OrganizationDetailsScreenState();
}

class _OrganizationDetailsScreenState extends State<OrganizationDetailsScreen> {
  BalanceOperationFilter _transactionFilter = BalanceOperationFilter.all;
  bool _isConnectionHistoryExpanded = false;

  @override
  void initState() {
    super.initState();
    context
        .read<OrganizationByIdBloc>()
        .add(FetchOrganizationByIdEvent(widget.organizationId.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        elevation: 0,
        title: const Text(
          'Просмотр организации',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            color: Color(0xff1E2E52),
          ),
        ),
      ),
      body: BlocConsumer<OrganizationByIdBloc, OrganizationByIdState>(
        listener: (context, state) {
          if (state is OrganizationByIdError) {
            showCustomSnackBar(
              context: context,
              message: state.message,
              isSuccess: false,
            );
          }
        },
        builder: (context, state) {
          if (state is OrganizationByIdLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xff1E2E52)),
            );
          }

          if (state is OrganizationByIdLoaded) {
            return RefreshIndicator(
              color: const Color(0xff1E2E52),
              onRefresh: () async {
                context.read<OrganizationByIdBloc>().add(
                      FetchOrganizationByIdEvent(
                          widget.organizationId.toString()),
                    );
              },
              child: _buildContent(state.organizationDetails),
            );
          }

          if (state is OrganizationByIdError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text('Нет данных для отображения'));
        },
      ),
    );
  }

  Widget _buildContent(OrganizationDetails details) {
    final filteredTransactions = _filterTransactions(details.balanceOperations);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _buildOverviewSection(details),
        const SizedBox(height: 16),
        _buildServicesSection(details.connectedServices),
        const SizedBox(height: 16),
        _buildHistorySection(details.connectionStatusHistory),
        const SizedBox(height: 16),
        _buildTransactionsSection(filteredTransactions),
      ],
    );
  }

  Widget _buildOverviewSection(OrganizationDetails details) {
    final organization = details.organization;
    final client = details.client;
    final primaryTariff = details.connectedServices.isNotEmpty
        ? details.connectedServices.first.tariffName
        : 'Не указан';

    return _buildSectionCard(
      title: 'Организация',
      child: Column(
        children: [
          _buildOverviewInfoRow(
            'ID',
            organization.orderNumber,
            isCopyable: true,
          ),
          _buildOverviewInfoRow(
            'Название',
            _valueOrFallback(organization.name),
            isCopyable: true,
          ),
          _buildOverviewInfoRow('Телефон', _valueOrFallback(client.phone)),
          _buildOverviewInfoRow('Почта', _valueOrFallback(client.email)),
          _buildOverviewInfoRow('Клиент', _valueOrFallback(client.name)),
          _buildOverviewInfoRow(
              'Партнер', _valueOrFallback(client.partnerName)),
          _buildOverviewInfoRow('Тариф', primaryTariff),
          _buildOverviewInfoRow('Поддомен', _valueOrFallback(client.subDomain)),
          _buildOverviewInfoRow(
            'Статус',
            client.isActive ? 'Активный' : 'Неактивный',
            valueColor: client.isActive ? Colors.green : Colors.red,
          ),
          _buildOverviewInfoRow(
            'Последняя активность',
            _formatDateTime(client.lastActivity, withTime: true),
          ),
          _buildOverviewInfoRow(
            'Срок действие',
            _formatDateTime(organization.calculatedValidUntil),
          ),
          _buildOverviewInfoRow(
            'Баланс',
            _formatMoney(details.realBalance, client.currencySymbolCode),
            valueColor: const Color(0xff1E2E52),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection(List<ConnectedService> services) {
    return _buildSectionCard(
      title: 'Подключенные услуги',
      child: services.isEmpty
          ? _buildEmptySection('Услуги не найдены')
          : Column(
              children: [
                const Divider(height: 1, color: Color(0xffE2E8F0)),
                ...List.generate(
                  services.length,
                  (index) => Column(
                    children: [
                      _buildServiceTableRow(services[index], index + 1),
                      if (index != services.length - 1)
                        const Divider(height: 1, color: Color(0xffEEF2F7)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHistorySection(List<ConnectionStatusHistoryItem> history) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isConnectionHistoryExpanded = !_isConnectionHistoryExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7FD),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xffE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHistoryTitleRow('История подключений'),
            const SizedBox(height: 8),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: _isConnectionHistoryExpanded
                  ? history.isEmpty
                      ? _buildEmptySection('История не найдена')
                      : SizedBox(
                          height: 280,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: history
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      child: _buildConnectionHistoryItem(
                                        entry.value,
                                        entry.key + 1,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsSection(List<BalanceOperation> transactions) {
    return _buildSectionCard(
      title: 'Транзакции',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip('Все', BalanceOperationFilter.all),
              _buildFilterChip('Пополнения', BalanceOperationFilter.income),
              _buildFilterChip('Списания', BalanceOperationFilter.outcome),
            ],
          ),
          const SizedBox(height: 16),
          if (transactions.isEmpty)
            _buildEmptySection('Транзакции не найдены')
          else
            Column(
              children: List.generate(
                transactions.length,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    bottom: index == transactions.length - 1 ? 0 : 12,
                  ),
                  child: _buildListTileCard(
                    leading: '${index + 1}',
                    title: _formatDateTime(transactions[index].date,
                        withTime: true),
                    trailing: _buildStatusChip(
                      transactions[index].type == 'income'
                          ? 'Пополнение'
                          : 'Списание',
                      transactions[index].type == 'income'
                          ? Colors.green
                          : Colors.redAccent,
                    ),
                    rows: [
                      _metaPair(
                        'Сумма',
                        _formatMoney(
                          transactions[index].amount,
                          transactions[index].currencyCode,
                        ),
                      ),
                      _metaPair('Валюта',
                          _valueOrFallback(transactions[index].currencyCode)),
                      _metaPair(
                          'ID операции', transactions[index].id.toString()),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      decoration: TaskCardStyles.taskCardDecoration.copyWith(
        color: Colors.white,
        border: Border.all(color: const Color(0xffE2E8F0)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w700,
              color: Color(0xff1E2E52),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildHistoryTitleRow(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w500,
            color: Color(0xff1E2E52),
          ),
        ),
        AnimatedRotation(
          turns: _isConnectionHistoryExpanded ? 0.5 : 0,
          duration: const Duration(milliseconds: 200),
          child: Image.asset(
            'assets/icons/dropdown.png',
            width: 16,
            height: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildConnectionHistoryItem(
      ConnectionStatusHistoryItem item, int index) {
    final documentText = item.commercialOfferId != null
        ? 'КП #${item.commercialOfferId}'
        : 'Не указан';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${_humanizeStatus(item.status)} #$index',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    color: Color(0xff1E2E52),
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  '${_valueOrFallback(item.authorName)}, ${_formatDateTime(item.statusDate, withTime: true)}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
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
          ),
          const SizedBox(height: 12),
          _buildStatusChip(
            _humanizeStatus(item.status),
            _statusColor(item.status),
          ),
          const SizedBox(height: 10),
          _buildHistoryMetaRow(
            'Документ',
            documentText,
            valueColor: item.commercialOfferId != null
                ? const Color(0xff204ECF)
                : const Color(0xff7B879C),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTableRow(ConnectedService service, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 28,
                child: Text(
                  '$index',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1E2E52),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 5,
                child: _buildServiceCell(
                  'Услуга',
                  service.tariffName,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _buildServiceCell(
                  'Кол-во',
                  service.quantity.toString(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: _buildServiceCell(
                  'Валюта',
                  _valueOrFallback(service.currencyCode),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 40),
              Expanded(
                flex: service.deactivatedAt != null ? 4 : 8,
                child: _buildServiceCell(
                  'Дата подключение',
                  _formatDateTime(service.connectedAt, withTime: true),
                ),
              ),
              if (service.deactivatedAt != null) ...[
                const SizedBox(width: 12),
                Expanded(
                  flex: 4,
                  child: _buildServiceCell(
                    'Дата отключение',
                    _formatDateTime(service.deactivatedAt, withTime: true),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 40),
              Expanded(
                flex: 4,
                child: _buildServiceCell(
                  'Сумма в месяц',
                  _formatMoney(service.monthlyAmount, service.currencyCode),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Активность',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w400,
                        color: Color(0xff7B879C),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildStatusChip(
                      service.isActive ? 'Активна' : 'Неактивна',
                      service.isActive ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCell(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w400,
            color: Color(0xff7B879C),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w500,
            color: Color(0xff1E2E52),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryMetaRow(String label, String value, {Color? valueColor}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w400,
              color: Color(0xff7B879C),
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w400,
              color: valueColor ?? const Color(0xff1E2E52),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTileCard({
    required String leading,
    required String title,
    Widget? trailing,
    required List<MapEntry<String, String>> rows,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffE7EDF6)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xffEAF0FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  leading,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1E2E52),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    color: Color(0xff1E2E52),
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 12),
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildInfoRow(row.key, row.value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    Color? valueColor,
    bool isCopyable = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w400,
              color: Color(0xff7B879C),
            ),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          flex: 6,
          child: GestureDetector(
            onLongPress:
                isCopyable ? () => _copyToClipboard(label, value) : null,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w500,
                color: valueColor ?? const Color(0xff1E2E52),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewInfoRow(
    String label,
    String value, {
    Color? valueColor,
    bool isCopyable = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _buildInfoRow(
        label,
        value,
        valueColor: valueColor,
        isCopyable: isCopyable,
      ),
    );
  }

  Future<void> _copyToClipboard(String label, String value) async {
    if (value.trim().isEmpty || value == 'Не указан') return;

    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label скопирован'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget _buildFilterChip(String label, BalanceOperationFilter filter) {
    final isSelected = _transactionFilter == filter;
    final color = filter == BalanceOperationFilter.income
        ? Colors.green
        : filter == BalanceOperationFilter.outcome
            ? Colors.redAccent
            : const Color(0xff1E2E52);

    return GestureDetector(
      onTap: () {
        setState(() {
          _transactionFilter = filter;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.12) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: isSelected ? color : const Color(0xffD6DEEB)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            color: isSelected ? color : const Color(0xff1E2E52),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _buildEmptySection(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w500,
            color: Color(0xff7B879C),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  List<BalanceOperation> _filterTransactions(
      List<BalanceOperation> operations) {
    switch (_transactionFilter) {
      case BalanceOperationFilter.income:
        return operations.where((item) => item.type == 'income').toList();
      case BalanceOperationFilter.outcome:
        return operations.where((item) => item.type == 'outcome').toList();
      case BalanceOperationFilter.all:
        return operations;
    }
  }

  MapEntry<String, String> _metaPair(String label, String value) =>
      MapEntry(label, value);

  String _formatMoney(double amount, String currencyCode) {
    final formatter = NumberFormat('#,##0.00##', 'en_US');
    final formattedAmount = formatter.format(amount);
    return currencyCode.isEmpty
        ? formattedAmount
        : '$formattedAmount $currencyCode';
  }

  String _formatDateTime(DateTime? dateTime, {bool withTime = false}) {
    if (dateTime == null) return 'Не указана';
    final format = withTime ? 'dd.MM.yyyy HH:mm' : 'dd.MM.yyyy';
    return DateFormat(format).format(dateTime.toLocal());
  }

  String _humanizeStatus(String status) {
    switch (status) {
      case 'connected':
        return 'Подключено';
      case 'disconnected':
        return 'Отключено';
      default:
        return status.isEmpty ? 'Не указан' : status;
    }
  }

  String _valueOrFallback(String? value) {
    final normalized = value?.trim() ?? '';
    return normalized.isEmpty ? 'Не указан' : normalized;
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'connected':
        return Colors.green;
      case 'disconnected':
        return Colors.redAccent;
      default:
        return const Color(0xff1E2E52);
    }
  }
}
