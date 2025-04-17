import 'package:intl/intl.dart';

String timeCustom(String dateAndTime) {
  try {
    final dateTime = DateTime.parse(dateAndTime).toLocal();
    return DateFormat('HH:mm').format(dateTime);
  } catch (e) {
    return dateAndTime;
  }
}


String dateCustom(String dateAndTime) {
  try {
    final dateTime = DateTime.parse(dateAndTime).toLocal();
    return DateFormat('yyyy-MM-dd').format(dateTime);
  } catch (e) {
    return dateAndTime;
  }
}
