import 'package:admin_menu_mobile/features/order/bloc/order_bloc.dart';
import 'package:admin_menu_mobile/screens/order_detail_screen/order_detail_view.dart';
import 'package:admin_menu_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, this.idOrder});
  final String? idOrder;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => OrderBloc()..add(GetOrderByID(idOrder: idOrder)),
        child: Scaffold(
            appBar: _buildAppbar(context), body: const OrderDetailView()));
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        title: Text('$idOrder',
            style: context.titleStyleMedium!
                .copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton.filled(
              iconSize: 20, onPressed: () {}, icon: const Icon(Icons.add))
        ]);
  }
}
