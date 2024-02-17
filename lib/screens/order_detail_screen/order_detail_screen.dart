import 'package:admin_menu_mobile/screens/order_detail_screen/order_detail_view.dart';
import 'package:admin_menu_mobile/utils/utils.dart';
import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, this.idOrder});
  final String? idOrder;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppbar(context), body: const OrderDetailView());
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        title: Text('$idOrder',
            style: context.titleStyleMedium!
                .copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true);
  }
}
