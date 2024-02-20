import 'package:admin_menu_mobile/features/order/bloc/order_bloc.dart';
import 'package:admin_menu_mobile/screens/order_detail_screen/order_detail_view.dart';
import 'package:admin_menu_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_alerts.dart';
import '../../widgets/widgets.dart';

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
        actions: [_DeleteOrder(idOrder: idOrder!)]);
  }
  //  color: context.colorScheme.errorContainer,
  //             iconSize: 20,
  //             onPressed: () {},
  //             icon: const Icon(Icons.delete_forever)
}

class _DeleteOrder extends StatelessWidget {
  final String idOrder;

  const _DeleteOrder({required this.idOrder});
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: defaultPadding / 2),
        width: 90,
        height: 25,
        child: FilledButton.icon(
            style: ButtonStyle(
                iconSize: const MaterialStatePropertyAll(15),
                backgroundColor: MaterialStatePropertyAll(
                    context.colorScheme.errorContainer)),
            icon: const Icon(Icons.delete_outlined),
            label: FittedBox(
                child: Text('Xóa đơn', style: context.textStyleSmall)),
            onPressed: () => _handleDeleteOrder(context, idOrder)));
  }

  void _handleDeleteOrder(BuildContext context, String idOrder) {
    final FToast fToast = FToast()..init(context);
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
              height: 200,
              child: CommonBottomSheet(
                  title: "Bạn có muốn xóa đơn này không?",
                  textConfirm: 'Xóa',
                  textCancel: "Hủy",
                  textConfirmColor: context.colorScheme.errorContainer,
                  onCancel: () {
                    context.pop();
                  },
                  onConfirm: () {
                    context.pop();
                    context
                        .read<OrderBloc>()
                        .add(DeleteOrder(idOrder: idOrder));
                    fToast.showToast(
                        child: AppAlerts.successToast(msg: 'Đã xóa'));
                    context.pop();
                  }));
        });
  }
}
