import 'package:admin_menu_mobile/utils/utils.dart';
import 'package:flutter/material.dart';

import 'order_history_detail_view.dart';

class OrderHistoryDetailScreen extends StatelessWidget {
  const OrderHistoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppbar(context), body: const OrderHistoryDetailView());
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        title: Text('Chi tiết đơn hàng',
            style: context.titleStyleMedium!
                .copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true);
  }
}
