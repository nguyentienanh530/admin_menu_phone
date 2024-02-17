import 'package:intl/intl.dart';

class Ultils {
  static String currencyFormat(double double) {
    final oCcy = NumberFormat("###,###,###", "vi");
    return "${oCcy.format(double)} đ";
  }

  static String formatDateTime(String dateTimeString) {
    final inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    final outputFormat = DateFormat('HH:mm - dd/MM/yyyy');

    final dateTime = inputFormat.parse(dateTimeString);
    return outputFormat.format(dateTime);
  }
}
