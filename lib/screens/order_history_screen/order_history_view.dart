import 'package:admin_menu_mobile/config/config.dart';
import 'package:admin_menu_mobile/features/order/bloc/order_bloc.dart';
import 'package:admin_menu_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../features/order/dtos/order_model.dart';
import '../../widgets/widgets.dart';

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    var loadingOrInit = Center(
        child: SpinKitCircle(color: context.colorScheme.primary, size: 30));
    return BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
      return (switch (state.status) {
        OrderStatus.loading => loadingOrInit,
        OrderStatus.failure => Center(child: Text(state.message)),
        OrderStatus.success => _buildBody(context, state.orders),
        OrderStatus.initial => loadingOrInit
      });
    });
  }

  Widget _buildBody(BuildContext context, List<OrderModel> orders) {
    return GroupedListView(
        elements: orders,
        groupBy: (element) => Ultils.formatToDate(element.datePay!),
        itemComparator: (element1, element2) =>
            element2.datePay!.compareTo(element1.datePay!),
        order: GroupedListOrder.DESC,
        useStickyGroupSeparators: true,
        floatingHeader: true,
        groupSeparatorBuilder: (String value) {
          var totalPrice = 0.0;
          for (var element in orders) {
            if (Ultils.formatToDate(element.datePay!) == value) {
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
                  style: context.textStyleMedium));
        },
        itemBuilder: (context, element) {
          return _buildItemListView(context, element);
        });
  }

  Widget _buildItemListView(BuildContext context, OrderModel? orderModel) {
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
                      CommonLineText(title: 'Bàn: ', value: orderModel.table!),
                      CommonLineText(
                          title: 'Thời gian đặt: ',
                          value: Ultils.formatDateTime(orderModel.dateOrder!)),
                      CommonLineText(
                          title: 'Thời thanh toán: ',
                          value: Ultils.formatDateTime(orderModel.datePay!))
                    ]),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonLineText(
                          color: context.colorScheme.secondaryContainer,
                          title: 'Tổng tiền: ',
                          value: Ultils.currencyFormat(
                              double.parse(orderModel.totalPrice!.toString()))),
                      SizedBox(height: defaultPadding / 2),
                      InkWell(
                          onTap: () {
                            context.push(RouteName.orderHistoryDetail);
                            // Get.to<HistoryOrderDetail>(() => HistoryOrderDetail(
                            //     idTable: orderModel.id.toString(),
                            //     nameTable: orderModel.id));
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
              ])),
    );
  }
}
