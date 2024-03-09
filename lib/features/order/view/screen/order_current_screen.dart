import 'package:admin_menu_mobile/common/bloc/generic_bloc_state.dart';
import 'package:admin_menu_mobile/features/order/bloc/order_bloc.dart';
import 'package:admin_menu_mobile/core/utils/utils.dart';
import 'package:admin_menu_mobile/common/widget/empty_screen.dart';
import 'package:admin_menu_mobile/common/widget/error_screen.dart';
import 'package:admin_menu_mobile/common/widget/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_menu_mobile/config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import '../../../../common/widget/common_line_text.dart';
import '../../data/model/order_model.dart';

class CurrentOrder extends StatefulWidget {
  const CurrentOrder({super.key});

  @override
  State<CurrentOrder> createState() => _CurrentOrderState();
}

class _CurrentOrderState extends State<CurrentOrder>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
        create: (context) => OrderBloc()..add(AllOrderFetched()),
        child: const Scaffold(body: OrderHistoryView()));
  }

  @override
  bool get wantKeepAlive => true;
}

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
        onRefresh: () async => context.read<OrderBloc>().add(AllOrderFetched()),
        child: BlocBuilder<OrderBloc, GenericBlocState<Orders>>(
            builder: (context, state) {
          return (switch (state.status) {
            Status.loading => const LoadingScreen(),
            Status.empty => const EmptyScreen(),
            Status.failure => ErrorScreen(errorMsg: state.error),
            Status.success => _buildBody(context, state.datas as List<Orders>)
          });
        }));
  }

  Widget _buildBody(BuildContext context, List<Orders> orders) {
    return GroupedListView(
        physics: const BouncingScrollPhysics(),
        elements: orders,
        groupBy: (element) => element.tableName,
        itemComparator: (element1, element2) =>
            element2.tableID!.compareTo(element1.tableID!),
        order: GroupedListOrder.DESC,
        useStickyGroupSeparators: true,
        floatingHeader: true,
        groupSeparatorBuilder: (String value) {
          return Container(
              width: context.sizeDevice.width * 3 / 4,
              decoration: BoxDecoration(
                  color: context.colorScheme.primary,
                  borderRadius: BorderRadius.circular(defaultBorderRadius)),
              padding: EdgeInsets.all(defaultPadding),
              margin: EdgeInsets.all(defaultPadding),
              child: Text(value,
                  textAlign: TextAlign.center,
                  style: context.textStyleMedium!.copyWith(
                      color: context.colorScheme.tertiary,
                      fontWeight: FontWeight.bold)));
        },
        itemBuilder: (context, element) {
          return _buildItemListView(context, element)
              .animate()
              .slideX(
                  begin: -0.1,
                  end: 0,
                  curve: Curves.easeInOutCubic,
                  duration: 500.ms)
              .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms);
        });
  }

  Widget _buildItemListView(BuildContext context, Orders? orderModel) {
    return GestureDetector(
        onTap: () async {
          await context
              .push(RouteName.orderDetail, extra: orderModel)
              .then((value) {
            if (!context.mounted) return;
            context.read<OrderBloc>().add(AllOrderFetched());
          });
        },
        child: Card(
            child: Container(
                padding: EdgeInsets.all(defaultPadding / 2),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonLineText(
                                title: 'ID: ', value: orderModel!.id!),
                            CommonLineText(
                                title: 'Bàn: ', value: orderModel.tableName),
                            CommonLineText(
                                title: 'Đặt lúc: ',
                                value: Ultils.formatDateTime(
                                    orderModel.orderTime!)),
                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Text('Xem chi tiết',
                                  style: context.textStyleSmall),
                              const Icon(Icons.navigate_next)
                            ]),
                            CommonLineText(
                                color: context.colorScheme.secondaryContainer,
                                title: 'Tổng tiền: ',
                                valueStyle: context.textStyleMedium!.copyWith(
                                    color: context.colorScheme.secondary,
                                    fontWeight: FontWeight.bold),
                                value: Ultils.currencyFormat(double.parse(
                                    orderModel.totalPrice!.toString()))),
                            SizedBox(height: defaultPadding / 2)
                          ])
                    ]))));
  }
}
