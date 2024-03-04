import 'package:admin_menu_mobile/common/bloc/generic_bloc_state.dart';
import 'package:admin_menu_mobile/features/order/bloc/order_bloc.dart';
import 'package:admin_menu_mobile/core/utils/utils.dart';
import 'package:admin_menu_mobile/common/widget/empty_screen.dart';
import 'package:admin_menu_mobile/common/widget/error_screen.dart';
import 'package:admin_menu_mobile/common/widget/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_menu_mobile/config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import '../../../../common/widget/common_line_text.dart';
import '../../data/model/order_model.dart';

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
        create: (context) => OrderBloc()..add(OrdersHistoryFecthed()),
        child:
            Scaffold(appBar: _buildAppbar(), body: const OrderHistoryView()));
  }

  _buildAppbar() {
    return AppBar(
        centerTitle: true,
        title: Text("Lịch sử đơn hàng", style: context.textStyleMedium));
  }

  @override
  bool get wantKeepAlive => true;
}

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, GenericBlocState<Orders>>(
        builder: (context, state) {
      return (switch (state.status) {
        Status.loading => const LoadingScreen(),
        Status.empty => const EmptyScreen(),
        Status.failure => ErrorScreen(errorMsg: state.error),
        Status.success => _buildBody(context, state.datas as List<Orders>),
      });
    });
  }

  Widget _buildBody(BuildContext context, List<Orders> orders) {
    return GroupedListView(
        elements: orders,
        groupBy: (element) => Ultils.formatToDate(element.payTime!),
        itemComparator: (element1, element2) =>
            element2.payTime!.compareTo(element1.payTime!),
        order: GroupedListOrder.DESC,
        useStickyGroupSeparators: true,
        floatingHeader: true,
        groupSeparatorBuilder: (String value) {
          var totalPrice = 0.0;
          for (var element in orders) {
            if (Ultils.formatToDate(element.payTime!) == value) {
              totalPrice =
                  totalPrice + double.parse(element.totalPrice.toString());
            }
          }
          return Container(
              width: context.sizeDevice.width * 3 / 4,
              decoration: BoxDecoration(
                  color: context.colorScheme.primary,
                  borderRadius: BorderRadius.circular(defaultBorderRadius)),
              padding: EdgeInsets.all(defaultPadding),
              margin: EdgeInsets.all(defaultPadding),
              child: Text(
                  '${Ultils.reverseDate(value)} - ${Ultils.currencyFormat(totalPrice)}',
                  textAlign: TextAlign.center,
                  style: context.textStyleMedium!.copyWith(
                      color: context.colorScheme.tertiary,
                      fontWeight: FontWeight.bold)));
        },
        itemBuilder: (context, element) {
          return _buildItemListView(context, element);
        });
  }

  Widget _buildItemListView(BuildContext context, Orders? orderModel) {
    return Card(
        child: Container(
            padding: EdgeInsets.all(defaultPadding / 2),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonLineText(title: 'ID: ', value: orderModel!.id!),
                        const CommonLineText(
                            title: 'Bàn: ', value: 'orderModel.table!'),
                        CommonLineText(
                            title: 'Thời gian đặt: ',
                            value:
                                Ultils.formatDateTime(orderModel.orderTime!)),
                        CommonLineText(
                            title: 'Thời thanh toán: ',
                            value: Ultils.formatDateTime(orderModel.orderTime!))
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonLineText(
                            color: context.colorScheme.secondaryContainer,
                            title: 'Tổng tiền: ',
                            valueStyle: context.textStyleMedium!.copyWith(
                                color: context.colorScheme.secondary,
                                fontWeight: FontWeight.bold),
                            value: Ultils.currencyFormat(double.parse(
                                orderModel.totalPrice!.toString()))),
                        SizedBox(height: defaultPadding / 2),
                        InkWell(
                            onTap: () {
                              context.push(RouteName.orderHistoryDetail,
                                  extra: orderModel);
                            },
                            child: Container(
                                width: 80,
                                height: 30,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: context.colorScheme.errorContainer,
                                    borderRadius: BorderRadius.circular(
                                        defaultBorderRadius)),
                                child: FittedBox(
                                    child: Text("Xem chi tiết",
                                        style: context.textStyleSmall))))
                      ])
                ])));
  }
}
