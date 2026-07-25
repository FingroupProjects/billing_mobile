import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/models/commercial_offer_model.dart';
import 'package:billing_mobile/screens/commercial_offers/commercial_offer_status_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommercialOfferDetailsScreen extends StatefulWidget {
  final CommercialOffer offer;

  const CommercialOfferDetailsScreen({
    super.key,
    required this.offer,
  });

  @override
  State<CommercialOfferDetailsScreen> createState() =>
      _CommercialOfferDetailsScreenState();
}

class _CommercialOfferDetailsScreenState
    extends State<CommercialOfferDetailsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<CommercialOfferStatus>> _statusesFuture;

  @override
  void initState() {
    super.initState();
    _statusesFuture = _apiService.getCommercialOfferStatuses(widget.offer.id);
  }

  void _refreshStatuses() {
    setState(() {
      _statusesFuture = _apiService.getCommercialOfferStatuses(widget.offer.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(
          'Просмотр подключения',
          style: TextStyle(
            color: Color(0xff1E2E52),
            fontSize: 20,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xff1E2E52)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        children: [
          _OfferInfoSection(offer: widget.offer),
          const SizedBox(height: 18),
          _StatusesContainer(
            offerId: widget.offer.id,
            statusesFuture: _statusesFuture,
            onStatusSaved: _refreshStatuses,
          ),
        ],
      ),
    );
  }
}

class _OfferInfoSection extends StatelessWidget {
  final CommercialOffer offer;

  const _OfferInfoSection({required this.offer});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DetailRow(label: 'Клиент:', value: offer.clientName),
        _DetailRow(label: 'Телефон:', value: offer.clientPhone),
        _DetailRow(label: 'Почта:', value: offer.clientEmail),
        _DetailRow(label: 'Партнер:', value: offer.partnerName),
        _DetailRow(
            label: 'Тип операции:', value: _requestTypeText(offer.requestType)),
        _DetailRow(
          label: 'Тип оплаты:',
          value:
              _paymentMethodText(offer.latestOfferStatus?.paymentMethod ?? ''),
        ),
        _DetailRow(label: 'Статус:', value: _statusText(offer.status)),
        _DetailRow(
            label: 'Дата операции:', value: _formatShortDate(offer.createdAt)),
        _DetailRow(label: 'Тариф:', value: offer.tariff?.name ?? ''),
        _DetailRow(label: 'Период:', value: '${offer.periodMonths} мес.'),
        _DetailRow(
          label: 'Сумма оплаты:',
          value:
              '${_formatAmount(offer.payableTotal)} ${offer.payableCurrency}',
        ),
      ],
    );
  }
}

class _StatusesContainer extends StatefulWidget {
  final int offerId;
  final Future<List<CommercialOfferStatus>> statusesFuture;
  final VoidCallback onStatusSaved;

  const _StatusesContainer({
    required this.offerId,
    required this.statusesFuture,
    required this.onStatusSaved,
  });

  @override
  State<_StatusesContainer> createState() => _StatusesContainerState();
}

class _StatusesContainerState extends State<_StatusesContainer> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return _DetailsContainer(
      title: 'История статусов подключения #${widget.offerId}',
      isExpanded: _isExpanded,
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      children: [
        if (_isExpanded)
          FutureBuilder<List<CommercialOfferStatus>>(
            future: widget.statusesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xff1E2E52)),
                  ),
                );
              }

              if (snapshot.hasError) {
                return const _EmptyText(
                    'Не удалось загрузить историю статусов');
              }

              final statuses = snapshot.data ?? [];
              if (statuses.isEmpty) {
                return const _EmptyText('История статусов пустая');
              }

              return Column(
                children: List.generate(statuses.length, (index) {
                  final status = statuses[index];
                  return _StatusHistoryItem(
                    status: status,
                    showDivider: index != statuses.length - 1,
                    onEdit: () async {
                      final saved = await showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => CommercialOfferStatusDialog(
                          offerId: widget.offerId,
                          initialStatus: status,
                        ),
                      );

                      if (saved == true) {
                        widget.onStatusSaved();
                      }
                    },
                  );
                }),
              );
            },
          ),
      ],
    );
  }
}

class _StatusHistoryItem extends StatelessWidget {
  final CommercialOfferStatus status;
  final bool showDivider;
  final VoidCallback onEdit;

  const _StatusHistoryItem({
    required this.status,
    required this.showDivider,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HistoryLine(
                label: 'Статус:',
                value: _statusText(status.status),
                isStrong: true,
              ),
              _HistoryLine(
                label: 'Дата:',
                value: _formatShortDate(status.statusDate),
                isStrong: true,
              ),
              _HistoryLine(
                label: 'Способ:',
                value: _paymentMethodText(status.paymentMethod),
              ),
              _HistoryLine(
                label: 'Автор:',
                value: status.author?.name ?? '',
              ),
              _HistoryLine(label: 'Счет:', value: _accountText(status.account)),
              _HistoryLine(
                label: '№ платежки:',
                value: status.paymentOrderNumber ?? '-',
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_square, size: 18),
                  label: const Text('Изменить'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xff1E2E52),
                    textStyle: const TextStyle(
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xffDDE3F0),
          ),
      ],
    );
  }
}

class _HistoryLine extends StatelessWidget {
  final String label;
  final String value;
  final bool isStrong;

  const _HistoryLine({
    required this.label,
    required this.value,
    this.isStrong = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w400,
                color: Color(0xff99A4BA),
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Gilroy',
                fontWeight: isStrong ? FontWeight.w700 : FontWeight.w500,
                color: const Color(0xff1E2E52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsContainer extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool isExpanded;
  final VoidCallback onTap;

  const _DetailsContainer({
    required this.title,
    required this.children,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7FD),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1E2E52),
                    ),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: const Color(0xff1E2E52),
                ),
              ],
            ),
            if (children.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...children,
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 128,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w400,
                color: Color(0xff99A4BA),
              ),
            ),
          ),
          Expanded(
            child: Text(
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
      ),
    );
  }
}

class _EmptyText extends StatelessWidget {
  final String text;

  const _EmptyText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: 'Gilroy',
          color: Color(0xff99A4BA),
        ),
      ),
    );
  }
}

String _formatShortDate(DateTime? value) {
  if (value == null) return '';
  return DateFormat('dd.MM.yyyy').format(value);
}

String _formatAmount(String value) {
  final number = double.tryParse(value) ?? 0;
  return NumberFormat('#,##0.00', 'ru_RU').format(number);
}

String _accountText(CommercialOfferAccount? account) {
  if (account == null) return '';
  if (account.currencyCode.isEmpty) return account.name;
  return '${account.name} (${account.currencyCode})';
}

String _statusText(String value) {
  switch (value) {
    case 'pending':
      return 'В ожидании';
    case 'paid':
      return 'Оплачено';
    case 'canceled':
      return 'Отменено';
    case 'draft':
      return 'Черновик';
    case 'rejected':
      return 'Отклонено';
    default:
      return value;
  }
}

String _requestTypeText(String value) {
  switch (value) {
    case 'connection':
      return 'Подключение';
    default:
      return value;
  }
}

String _paymentMethodText(String value) {
  switch (value) {
    case 'invoice':
      return 'Счет';
    case 'card':
      return 'Карта';
    case 'cash':
      return 'Наличка';
    default:
      return value;
  }
}
