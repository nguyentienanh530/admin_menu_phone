import 'package:admin_menu_mobile/common/bloc/generic_bloc_state.dart';
import 'package:admin_menu_mobile/features/order/bloc/order_bloc.dart';
import 'package:admin_menu_mobile/features/table/data/model/table_model.dart';
import 'package:admin_menu_mobile/common/widget/error_screen.dart';
import 'package:admin_menu_mobile/common/widget/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_menu_mobile/config/router.dart';
import 'package:admin_menu_mobile/common/widget/empty_screen.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/dialog/progress_dialog.dart';
import '../../../../common/dialog/retry_dialog.dart';
import '../../../../common/widget/common_bottomsheet.dart';
import '../../../../common/widget/common_icon_button.dart';
import '../../../../common/widget/common_line_text.dart';
import '../../data/model/order_model.dart';
import '../../../../core/utils/utils.dart';

class OrderOnTable extends StatelessWidget {
  const OrderOnTable({super.key, this.tableModel});
  final TableModel? tableModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppbar(context),
        body: BlocProvider(
            create: (context) => OrderBloc(),
            child: OrderView(tableModel: tableModel ?? TableModel())));
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        title: Text(' ${AppString.titleOrder} - ${tableModel!.name}',
            style: context.titleStyleMedium),
        centerTitle: true);
  }
}

class OrderView extends StatefulWidget {
  const OrderView({super.key, this.tableModel});
  final TableModel? tableModel;

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  var orderState = GenericBlocState<Orders>();
  @override
  void initState() {
    _getData();
    super.initState();
  }

  void _getData() {
    if (!mounted) return;
    context
        .read<OrderBloc>()
        .add(OrdersFecthed(tableID: widget.tableModel!.id!));
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    orderState = context.watch<OrderBloc>().state;
    return switch (orderState.status) {
      Status.loading => const LoadingScreen(),
      Status.empty => const EmptyScreen(),
      Status.failure => ErrorScreen(errorMsg: orderState.error),
      Status.success => ListView.builder(
          itemCount: orderState.datas!.length,
          itemBuilder: (context, index) =>
              _buildItemListView(context, orderState.datas![index], index))
    };
  }

  Widget _buildItemListView(
      BuildContext context, Orders orderModel, int index) {
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 10,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderItem(context, index, orderModel),
              _buildBodyItem(orderModel)
            ]));
  }

  Widget _buildHeaderItem(BuildContext context, int index, Orders orders) =>
      Container(
          height: 40,
          color: context.colorScheme.primary.withOpacity(0.3),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Text('#${index + 1} - ',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          Ultils.currencyFormat(double.parse(
                              orders.totalPrice?.toString() ?? '0')),
                          style: TextStyle(
                              color: context.colorScheme.secondary,
                              fontWeight: FontWeight.bold))
                    ]),
                    Row(children: [
                      const SizedBox(width: 8),
                      CommonIconButton(
                          icon: Icons.edit,
                          onTap: () async {
                            await _goToEditOrder(context, orders);
                          }),
                      const SizedBox(width: 8),
                      CommonIconButton(
                          icon: Icons.delete,
                          color: context.colorScheme.errorContainer,
                          onTap: () {
                            _handleDeleteOrder(context, orders);
                          })
                    ])
                  ])));

  void _handleDeleteOrder(BuildContext context, Orders order) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return CommonBottomSheet(
              title: "Bạn có muốn xóa đơn này không?",
              textConfirm: 'Xóa',
              textCancel: "Hủy",
              textConfirmColor: context.colorScheme.errorContainer,
              onConfirm: () {
                context
                    .read<OrderBloc>()
                    .add(OrderDeleted(orderID: order.id ?? ''));
                showDialog(
                    context: context,
                    builder: (context) =>
                        BlocBuilder<OrderBloc, GenericBlocState<Orders>>(
                            builder: (context, state) => switch (state.status) {
                                  Status.loading => const ProgressDialog(
                                      descriptrion: "Đang xóa...",
                                      isProgressed: true),
                                  Status.empty => const SizedBox(),
                                  Status.failure => RetryDialog(
                                      title: 'Lỗi',
                                      onRetryPressed: () => context
                                          .read<OrderBloc>()
                                          .add(OrderDeleted(
                                              orderID: order.id ?? ''))),
                                  Status.success => ProgressDialog(
                                      descriptrion: "Xóa thành công!",
                                      isProgressed: false,
                                      onPressed: () {
                                        if (orderState.datas!.length <= 1) {
                                          FirebaseFirestore.instance
                                              .collection('table')
                                              .doc(order.tableID)
                                              .update({'isUse': false});
                                        }
                                        _getData();
                                        pop(context, 2);
                                      })
                                }));
              });
        });
  }

  _buildBodyItem(Orders orderModel) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonLineText(title: 'ID: ', value: orderModel.id ?? ''),
            const SizedBox(height: 8.0),
            CommonLineText(title: 'Bàn: ', value: orderModel.tableName),
            const SizedBox(height: 8.0),
            CommonLineText(
                title: 'Đặt lúc: ',
                value: Ultils.formatDateTime(
                    orderModel.orderTime ?? DateTime.now().toString()))
          ]));

  _goToEditOrder(BuildContext context, Orders orders) async {
    await context.push(RouteName.orderDetail, extra: orders).then((value) =>
        context.read<OrderBloc>().add(OrdersFecthed(tableID: orders.tableID!)));
  }
}
