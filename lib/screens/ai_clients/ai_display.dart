import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AiDisplay {
  static const _dateTime = 'dd.MM.yyyy HH:mm';
  static const _time = 'HH:mm';
  static const _date = 'dd.MM.yyyy';

  static String typeLabel(String type) {
    switch (type) {
      case 'deduction':
        return 'Списание за использование';
      case 'payment':
        return 'Оплата тарифа';
      case 'topup':
        return 'Пополнение';
      case 'tariff_grant_prorated':
        return 'Пропорц. начисление лимита';
      case 'monthly_purchase':
        return 'Покупка лимита';
      default:
        return type.isEmpty ? 'Операция' : type;
    }
  }

  static Color typeColor(String type) {
    switch (type) {
      case 'deduction':
        return const Color(0xffE67E22);
      case 'payment':
        return const Color(0xff1B7A4E);
      case 'topup':
        return const Color(0xff22A06B);
      case 'tariff_grant_prorated':
        return const Color(0xff3D8BDB);
      case 'monthly_purchase':
        return const Color(0xffC75B39);
      default:
        return const Color(0xff99A4BA);
    }
  }

  static Color typeBackground(String type) {
    switch (type) {
      case 'deduction':
        return const Color(0xffFFF4E8);
      case 'payment':
        return const Color(0xffE7F6EE);
      case 'topup':
        return const Color(0xffE8F8F0);
      case 'tariff_grant_prorated':
        return const Color(0xffEAF4FF);
      case 'monthly_purchase':
        return const Color(0xffFBECE6);
      default:
        return const Color(0xffF1F3F7);
    }
  }

  static String accountLabel(String target) {
    switch (target) {
      case 'limited':
        return 'Лимит';
      case 'ai_balance':
        return 'Кошелёк ИИ';
      default:
        return target.isEmpty ? '—' : target;
    }
  }

  static String dateTime(DateTime? value) {
    if (value == null) return '—';
    return DateFormat(_dateTime).format(value.toLocal());
  }

  static String period(DateTime? start, DateTime? end) {
    if (start == null && end == null) return '—';
    if (start == null) return dateTime(end);
    if (end == null) return dateTime(start);

    final localStart = start.toLocal();
    final localEnd = end.toLocal();
    final sameDay = localStart.year == localEnd.year &&
        localStart.month == localEnd.month &&
        localStart.day == localEnd.day;

    if (sameDay) {
      return '${DateFormat(_date).format(localStart)} ${DateFormat(_time).format(localStart)} — ${DateFormat(_time).format(localEnd)}';
    }
    return '${DateFormat(_dateTime).format(localStart)} — ${DateFormat(_dateTime).format(localEnd)}';
  }

  static String usd(dynamic value, {int decimals = 4}) {
    final number = value is num
        ? value.toDouble()
        : double.tryParse(value?.toString() ?? '') ?? 0;
    final pattern = decimals <= 0
        ? '#,##0'
        : '#,##0.${List.filled(decimals, '0').join()}';
    return '${NumberFormat(pattern, 'ru_RU').format(number)} USD';
  }

  static String tokens(int total, int cache) {
    final formatter = NumberFormat('#,##0', 'ru_RU');
    if (cache > 0) {
      return '${formatter.format(total)} (cache ${formatter.format(cache)})';
    }
    return formatter.format(total);
  }
}
