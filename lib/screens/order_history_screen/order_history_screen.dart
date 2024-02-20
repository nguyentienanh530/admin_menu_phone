import 'package:admin_menu_mobile/features/order/bloc/order_bloc.dart';
import 'package:admin_menu_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'order_history_view.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => OrderBloc()..add(GetOrderHistory()),
      child: Scaffold(appBar: _buildAppbar(), body: const OrderHistoryView()),
    );
  }

  _buildAppbar() {
    return AppBar(
        centerTitle: true,
        title: Text("Lịch sử đơn hàng", style: context.textStyleMedium));
  }

  @override
  bool get wantKeepAlive => true;
}
