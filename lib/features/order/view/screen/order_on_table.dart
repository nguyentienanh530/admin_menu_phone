import 'package:admin_menu_mobile/common/bloc/generic_bloc_state.dart';
import 'package:admin_menu_mobile/common/dialog/app_alerts.dart';
import 'package:admin_menu_mobile/common/widget/_print_bottom_sheet.dart';
import 'package:admin_menu_mobile/features/order/bloc/order_bloc.dart';
import 'package:admin_menu_mobile/features/order/data/model/food_dto.dart';
import 'package:admin_menu_mobile/features/print/cubit/is_use_print_cubit.dart';
import 'package:admin_menu_mobile/features/print/cubit/print_cubit.dart';
import 'package:admin_menu_mobile/features/print/data/model/print_model.dart';
import 'package:admin_menu_mobile/features/table/data/model/table_model.dart';
import 'package:admin_menu_mobile/common/widget/error_screen.dart';
import 'package:admin_menu_mobile/common/widget/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_menu_mobile/config/router.dart';
import 'package:admin_menu_mobile/common/widget/empty_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    return BlocProvider(
        create: (context) => OrderBloc(),
        child: OrderView(tableModel: tableModel ?? TableModel()));
  }
}

class OrderView extends StatefulWidget {
  const OrderView({super.key, this.tableModel});
  final TableModel? tableModel;

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  var _orderState = GenericBlocState<Orders>();
  var _tableModel = TableModel();
  var _isUsePrint = false;
  var _print = PrintModel();
  final _loading = ValueNotifier(false);

  @override
  void initState() {
    _tableModel = widget.tableModel ?? TableModel();

    _getData();

    super.initState();
  }

  void _getData() {
    if (!mounted) return;
    context.read<OrderBloc>().add(OrdersFecthed(tableID: _tableModel.id ?? ''));
  }

  void _updateTable() {
    if (_orderState.datas == null || _orderState.datas!.isEmpty) {
      FirebaseFirestore.instance
          .collection('table')
          .doc(_tableModel.id)
          .update({'isUse': false});
    }
  }

  void _handlePrint(List<FoodDto> lst) async {
    var newList = [];
    for (var element in lst) {
      newList.add(
          '${_tableModel.id} - ${_tableModel.name} - ${element.foodName} - ${element.quantity} - ${element.totalPrice}');
    }

    _loading.value = true;
    final toast = FToast()..init(context);
    if (_print.id.isNotEmpty) {
      await Ultils.sendPrintToServer(
              ip: _print.ip, port: _print.port, lst: newList)
          .then((value) {
        _loading.value = false;
        toast
          ..removeQueuedCustomToasts()
          ..showToast(child: AppAlerts.successToast(msg: 'in thành công!'));
      }).onError((error, stackTrace) {
        _loading.value = false;
        toast
          ..removeQueuedCustomToasts()
          ..showToast(child: AppAlerts.errorToast(msg: error.toString()));
      });
    } else {
      _loading.value = false;
      toast
        ..removeQueuedCustomToasts()
        ..showToast(child: AppAlerts.errorToast(msg: 'Chưa chọn máy in!'));
    }
  }

  @override
  Widget build(BuildContext context) {
    _isUsePrint = context.watch<IsUsePrintCubit>().state;
    _print = context.watch<PrintCubit>().state;
    return Scaffold(appBar: _buildAppbar(context), body: _buildBody(context));
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        title: Text(' ${AppString.titleOrder} - ${_tableModel.name}',
            style: context.titleStyleMedium),
        centerTitle: true,
        actions: [
          _isUsePrint
              ? CommonIconButton(
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => SizedBox(
                            height: context.sizeDevice.height * 0.9,
                            child: PrintBottomSheet(
                                listFoodDto: _handlePrintFood(),
                                onPressedPrint: () {
                                  _handlePrint(_handlePrintFood());
                                })));
                  },
                  icon: Icons.print)
              : const SizedBox(),
          const SizedBox(width: 8)
        ]);
  }

  List<FoodDto> _handlePrintFood() {
    var newListFoodDto = <FoodDto>[];
    Map<String, FoodDto> uniqueFoods = {};
    _orderState.datas?.forEach((e) => newListFoodDto.addAll(e.foods));

    for (var food in newListFoodDto) {
      if (uniqueFoods.containsKey(food.foodID)) {
        uniqueFoods[food.foodID] = uniqueFoods[food.foodID]!.copyWith(
          quantity: uniqueFoods[food.foodID]!.quantity + 1,
          totalPrice: uniqueFoods[food.foodID]!.totalPrice + food.foodPrice,
        );
      } else {
        // Nếu mặt hàng chưa tồn tại, thêm vào uniqueFoods
        uniqueFoods[food.foodID] =
            food.copyWith(quantity: 1, totalPrice: food.foodPrice);
      }
    }

    // Chuyển đổi map thành danh sách và trả về
    return uniqueFoods.values.toList();
  }

  Widget _buildBody(BuildContext context) {
    _orderState = context.watch<OrderBloc>().state;
    switch (_orderState.status) {
      case Status.loading:
        return const LoadingScreen();
      case Status.empty:
        _updateTable();
        return const EmptyScreen();
      case Status.failure:
        return ErrorScreen(errorMsg: _orderState.error);
      case Status.success:
        return ValueListenableBuilder(
            valueListenable: _loading,
            builder: (context, value, child) => value
                ? const LoadingScreen()
                : ListView.builder(
                    itemCount: _orderState.datas!.length,
                    itemBuilder: (context, index) => _buildItemListView(
                        context, _orderState.datas![index], index)));
    }
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
                      _isUsePrint
                          ? CommonIconButton(
                              onTap: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) => SizedBox(
                                        height: context.sizeDevice.height * 0.9,
                                        child: PrintBottomSheet(
                                            listFoodDto: orders.foods,
                                            onPressedPrint: () {
                                              context.pop();
                                              _handlePrint(orders.foods);
                                            })));
                              },
                              icon: Icons.print,
                              color: Colors.blueAccent)
                          : const SizedBox(),
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
                                        _getData();
                                        _updateTable();
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
    await context.push(RouteName.orderDetail, extra: orders).then((value) {
      // context.read<OrderBloc>().add(OrdersFecthed(tableID: orders.tableID!));
      _getData();
      _updateTable();
    });
  }
}
