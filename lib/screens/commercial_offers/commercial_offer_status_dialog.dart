import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/models/commercial_offer_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommercialOfferStatusDialog extends StatefulWidget {
  final int offerId;
  final CommercialOfferStatus? initialStatus;
  final String paymentMethod;

  const CommercialOfferStatusDialog({
    super.key,
    required this.offerId,
    this.initialStatus,
    this.paymentMethod = '',
  });

  @override
  State<CommercialOfferStatusDialog> createState() =>
      _CommercialOfferStatusDialogState();
}

class _CommercialOfferStatusDialogState
    extends State<CommercialOfferStatusDialog> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final _paymentOrderController = TextEditingController();
  late Future<List<CommercialOfferAccount>> _accountsFuture;
  late String _paymentMethod;

  String _status = 'paid';
  DateTime _statusDate = DateTime.now();
  int? _accountId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialStatus;
    if (initial != null) {
      _status = _normalizeStatus(initial.status);
      _statusDate = initial.statusDate ?? DateTime.now();
      _accountId = initial.account?.id;
      _paymentOrderController.text = initial.paymentOrderNumber ?? '';
      _paymentMethod = initial.paymentMethod;
    } else {
      _paymentMethod = widget.paymentMethod;
    }
    _paymentMethod = _paymentMethod.trim();
    _accountsFuture = _apiService.getAccounts();
  }

  @override
  void dispose() {
    _paymentOrderController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      locale: const Locale('ru'),
      initialDate: _statusDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Gilroy'),
            primaryTextTheme:
                Theme.of(context).primaryTextTheme.apply(fontFamily: 'Gilroy'),
            colorScheme: const ColorScheme.light(
              primary: Color(0xff4759FF),
              onPrimary: Colors.white,
              onSurface: Color(0xff1E2E52),
              surface: Colors.white,
            ),
            datePickerTheme: const DatePickerThemeData(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _statusDate = picked;
      });
    }
  }

  bool get _isCashPayment => _paymentMethod.toLowerCase() == 'cash';

  String _normalizeStatus(String value) {
    switch (value) {
      case 'paid':
      case 'canceled':
        return value;
      case 'pending':
      case 'draft':
      case 'rejected':
      default:
        return 'paid';
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await _apiService.createCommercialOfferStatus(
        offerId: widget.offerId,
        status: _status,
        statusDate: DateFormat('yyyy-MM-dd').format(_statusDate),
        paymentMethod: _paymentMethod.isEmpty ? 'invoice' : _paymentMethod,
        accountId: _isCashPayment ? null : _accountId,
        paymentOrderNumber:
            _isCashPayment ? null : _paymentOrderController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось сохранить статус подключения'),
          backgroundColor: Color(0xffFF4D3D),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Gilroy'),
        primaryTextTheme:
            Theme.of(context).primaryTextTheme.apply(fontFamily: 'Gilroy'),
        canvasColor: Colors.white,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color(0xff4759FF),
              surface: Colors.white,
              onSurface: const Color(0xff1E2E52),
            ),
      ),
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: DefaultTextStyle(
                style: _fieldTextStyle(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.initialStatus == null
                                ? 'Добавить статус подключения #${widget.offerId}'
                                : 'Изменить статус подключения #${widget.offerId}',
                            style: const TextStyle(
                              color: Color(0xff1E2E52),
                              fontSize: 18,
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed:
                              _isSaving ? null : () => Navigator.pop(context),
                          icon:
                              const Icon(Icons.close, color: Color(0xff99A4BA)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const _Label(text: 'Статус'),
                    _DropdownField<String>(
                      value: _status,
                      items: [
                        DropdownMenuItem(
                          value: 'paid',
                          child: _menuText('Оплачено'),
                        ),
                        DropdownMenuItem(
                          value: 'canceled',
                          child: _menuText('Отменено'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _status = value;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    const _Label(text: 'Дата'),
                    InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: _isSaving ? null : _pickDate,
                      child: InputDecorator(
                        decoration: _inputDecoration(),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                DateFormat('dd.MM.yyyy').format(_statusDate),
                                style: _fieldTextStyle(),
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: Color(0xff99A4BA),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (!_isCashPayment) ...[
                      const _Label(text: 'Номер платежки'),
                      TextFormField(
                        controller: _paymentOrderController,
                        enabled: !_isSaving,
                        cursorColor: const Color(0xff1E2E52),
                        decoration: _inputDecoration(
                            hintText: 'Введите номер платежки'),
                        style: _fieldTextStyle(),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Введите номер платежки';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      const _Label(text: 'Счет'),
                      FutureBuilder<List<CommercialOfferAccount>>(
                        future: _accountsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xff1E2E52),
                                ),
                              ),
                            );
                          }

                          final accounts = snapshot.data ?? [];
                          return DropdownButtonFormField<int>(
                            initialValue: accounts
                                    .any((account) => account.id == _accountId)
                                ? _accountId
                                : null,
                            decoration:
                                _inputDecoration(hintText: 'Выберите счет'),
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xff1E2E52),
                            ),
                            items: accounts
                                .map(
                                  (account) => DropdownMenuItem<int>(
                                    value: account.id,
                                    child: _menuText(account.title),
                                  ),
                                )
                                .toList(),
                            onChanged: _isSaving
                                ? null
                                : (value) {
                                    setState(() {
                                      _accountId = value;
                                    });
                                  },
                            validator: (value) {
                              if (value == null) {
                                return 'Выберите счет';
                              }
                              return null;
                            },
                            style: _fieldTextStyle(),
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed:
                                _isSaving ? null : () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFFF4F7FD),
                              foregroundColor: const Color(0xff1E2E52),
                              side: BorderSide.none,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Отмена',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _save,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff4759FF),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: const Color(0xff99A4BA),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Сохранить',
                                    style: TextStyle(
                                      fontFamily: 'Gilroy',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xff1E2E52),
          fontSize: 13,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _DropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: _inputDecoration(),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(14),
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: Color(0xff1E2E52),
      ),
      items: items,
      onChanged: onChanged,
      style: _fieldTextStyle(),
    );
  }
}

InputDecoration _inputDecoration({String? hintText}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(
      color: Color(0xff99A4BA),
      fontFamily: 'Gilroy',
      fontSize: 14,
    ),
    filled: true,
    fillColor: const Color(0xFFF4F7FD),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xffDDE3F0)),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xffFF4D3D)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xffFF4D3D)),
    ),
  );
}

TextStyle _fieldTextStyle() {
  return const TextStyle(
    color: Color(0xff1E2E52),
    fontSize: 14,
    fontFamily: 'Gilroy',
    fontWeight: FontWeight.w500,
  );
}

Text _menuText(String value) {
  return Text(
    value,
    overflow: TextOverflow.ellipsis,
    style: _fieldTextStyle(),
  );
}
