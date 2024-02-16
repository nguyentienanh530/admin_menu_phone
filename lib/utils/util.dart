import 'package:intl/intl.dart';

class Ultils {
  static String currencyFormat(double double) {
    final oCcy = NumberFormat("###,###,###", "vi");
    return "${oCcy.format(double)} đ";
  }
}
