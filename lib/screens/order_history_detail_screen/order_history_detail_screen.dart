import 'package:admin_menu_mobile/features/order/bloc/order_bloc.dart';
import 'package:admin_menu_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'order_history_detail_view.dart';

class OrderHistoryDetailScreen extends StatelessWidget {
  const OrderHistoryDetailScreen({super.key, required this.idOrder});
  final String idOrder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderBloc()..add(GetOrderByID(idOrder: idOrder)),
      child: Scaffold(
          appBar: _buildAppbar(context), body: const OrderHistoryDetailView()),
    );
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        title: Text('Chi tiết đơn hàng',
            style: context.titleStyleMedium!
                .copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true);
  }
}
