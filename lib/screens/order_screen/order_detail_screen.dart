import 'package:admin_menu_mobile/features/order/bloc/order_bloc.dart';
import 'package:admin_menu_mobile/features/order/cubit/total_price_cubit.dart';
import 'package:admin_menu_mobile/features/order/dtos/order_model.dart';
import 'package:admin_menu_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:admin_menu_mobile/features/order/dtos/food_dto.dart';
import 'package:admin_menu_mobile/utils/app_alerts.dart';
import '../../config/router.dart';
import '../../widgets/widgets.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.orders});
  final Orders orders;
  @override
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => TotalPriceCubit(),
        child: Scaffold(
            appBar: _buildAppbar(context),
            body: OrderDetailView(orders: orders)));
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        title: Text(orders.id!,
            style: context.titleStyleMedium!
                .copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [_DeleteOrder(idOrder: orders.id!)]);
  }
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
                    // context.pop();
                    // context
                    //     .read<OrderBloc>()
                    //     .add(DeleteOrder(idOrder: idOrder));
                    // fToast.showToast(
                    //     child: AppAlerts.successToast(msg: 'Đã xóa'));
                    // context.pop();
                  }));
        });
  }
}

class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key, required this.orders});
  final Orders orders;
  @override
  Widget build(BuildContext context) {
    logger.d('stststs: ${context.read<OrderBloc>().operation}');

    return _buildBody(context, orders);
  }

  Widget _buildBody(BuildContext context, Orders order) {
    return Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        child: Column(children: [
          Expanded(
              child: SingleChildScrollView(
                  child: Column(children: [
            Column(
                children: order.orderFood
                    .map((e) => _ItemFood(orderModel: order, food: e))
                    .toList()
                    .animate(interval: 50.ms)
                    .slideX(
                        begin: -0.1,
                        end: 0,
                        curve: Curves.easeInOutCubic,
                        duration: 500.ms)
                    .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms))
          ]))),
          _BottomAction(order: order)
        ]));
  }
}

// ignore: must_be_immutable
class _ItemFood extends StatefulWidget {
  _ItemFood({required this.orderModel, required this.food});
  Orders orderModel;
  FoodDto food;
  @override
  State<_ItemFood> createState() => __ItemFoodState();
}

class __ItemFoodState extends State<_ItemFood> {
  var _quantity = 0;

  @override
  void initState() {
    _quantity = widget.food.quantity ?? 1;
    context
        .read<TotalPriceCubit>()
        .onTotalPriceChanged(widget.orderModel.totalPrice ?? 1.0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
        child: Slidable(
            endActionPane: ActionPane(
                extentRatio: 0.3,
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                      borderRadius: BorderRadius.circular(defaultBorderRadius),
                      flex: 1,
                      // spacing: 8,
                      padding: EdgeInsets.all(defaultPadding),
                      onPressed: (ct) {
                        _handleDeleteItem(
                            context, widget.orderModel, widget.food);
                      },
                      backgroundColor: context.colorScheme.error,
                      foregroundColor: Colors.white,
                      icon: Icons.delete_forever)
                ]),
            child: _buildItem(context, widget.food, widget.orderModel)));
  }

  Widget _buildItem(BuildContext context, FoodDto food, Orders orderModel) {
    return Card(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              _buildImage(food),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(),
                Text(food.title!,
                    style: context.textStyleMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: defaultPadding / 2),
                _buildQuality()
              ])
            ]),
            Padding(
                padding: EdgeInsets.only(right: defaultPadding / 2),
                child: _PriceFoodItem(food: food))
          ]),
          food.note!.isNotEmpty
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Ghi chú: ",
                      style: context.textStyleMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                  Text(food.note!, style: context.textStyleSmall)
                ])
              : const SizedBox()
        ]));
  }

  Widget _buildImage(FoodDto food) {
    return Container(
        height: 50,
        width: 50,
        margin: EdgeInsets.all(defaultPadding / 2),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.3),
            image: DecorationImage(
                image: NetworkImage(food.image == null || food.image == ""
                    ? noImage
                    : food.image ?? ""),
                fit: food.isImageCrop == true ? BoxFit.cover : BoxFit.fill)));
  }

  Future _handleDeleteItem(
      BuildContext context, Orders orderModel, FoodDto food) {
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
              height: 200,
              child: CommonBottomSheet(
                  title: "Bạn có muốn xóa món ăn này không?",
                  textConfirm: 'Xóa',
                  textCancel: "Hủy",
                  textConfirmColor: context.colorScheme.errorContainer,
                  onCancel: () {
                    context.pop();
                  },
                  onConfirm: () {
                    var orders = <Map<String, dynamic>>[];
                    var totalPrice = 0.0;
                    orderModel.orderFood.remove(food);
                    orderModel.orderFood.map((e) {
                      orders.add(FoodDto().toJson());
                      totalPrice = totalPrice + e.totalPrice!;
                    }).toList();

                    // context.read<OrderBloc>().add(UpdateFoodInOrder(
                    //     idOrder: orderModel.id!,
                    //     json: orders,
                    //     totalPrice: totalPrice));
                    context.pop();
                  }));
        });
  }

  Widget _buildQuality() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      // LineText(title: "Số lượng: ", value: food.quantity.toString()),
      InkWell(
          onTap: () => _handleDecrement(context),
          child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: context.colorScheme.secondary),
              child: const Icon(Icons.remove, size: 20))),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text('$_quantity',
              style: context.textStyleSmall!
                  .copyWith(fontWeight: FontWeight.bold))),
      InkWell(
          onTap: () => _handleIncrement(context),
          child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: context.colorScheme.secondary),
              child: const Icon(Icons.add, size: 20)))
    ]);
  }

  void _handleDecrement(BuildContext context) {
    if (widget.food.quantity! > 1) {
      widget.food = widget.food.copyWith(
        quantity: widget.food.quantity! - 1,
        totalPrice: (widget.food.quantity! - 1) * widget.food.price!,
      );

      widget.orderModel = widget.orderModel.copyWith(
          orderFood: widget.orderModel.orderFood.map((element) {
        if (element.id == widget.food.id) {
          return element.copyWith(
              quantity: widget.food.quantity,
              totalPrice: widget.food.totalPrice);
        }
        return element;
      }).toList());

      var totalBill = widget.orderModel.orderFood
          .fold(0.0, (newsum, current) => newsum + current.totalPrice!);

      widget.orderModel = widget.orderModel.copyWith(totalPrice: totalBill);
      setState(() {
        _quantity = widget.food.quantity ?? 1;
      });
      context.read<TotalPriceCubit>().onTotalPriceChanged(totalBill);
      context.read<OrderBloc>().add(OrderUpdated(orders: widget.orderModel));
      // context.read<OrderBloc>().add(GetOrdersByID(orderID: orderModel.id!));
    }
  }

  void _handleIncrement(BuildContext context) {
    widget.food = widget.food.copyWith(
      quantity: widget.food.quantity! + 1,
      totalPrice: (widget.food.quantity! + 1) * widget.food.price!,
    );

    widget.orderModel = widget.orderModel.copyWith(
        orderFood: widget.orderModel.orderFood.map((element) {
      if (element.id == widget.food.id) {
        return element.copyWith(
            quantity: widget.food.quantity, totalPrice: widget.food.totalPrice);
      }
      return element;
    }).toList());

    var totalBill = widget.orderModel.orderFood
        .fold(0.0, (newsum, current) => newsum + current.totalPrice!);

    widget.orderModel = widget.orderModel.copyWith(totalPrice: totalBill);
    setState(() {
      _quantity = widget.food.quantity ?? 1;
    });
    context.read<TotalPriceCubit>().onTotalPriceChanged(totalBill);
    context.read<OrderBloc>().add(OrderUpdated(orders: widget.orderModel));
    // context.read<OrderBloc>().add(GetOrdersByID(orderID: orderModel.id!));
  }
}

class _BottomAction extends StatelessWidget {
  final Orders order;

  const _BottomAction({required this.order});
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Tổng tiền:", style: context.textStyleMedium),
                BlocBuilder<TotalPriceCubit, num>(
                    // buildWhen: (previous, current) => previous != current,
                    builder: (context, price) {
                  return Text(
                      Ultils.currencyFormat(double.parse(price.toString())),
                      style: context.textStyleMedium!.copyWith(
                          color: context.colorScheme.secondary,
                          fontWeight: FontWeight.bold));
                })
              ]),
              SizedBox(height: defaultPadding),
              order.orderFood.isNotEmpty
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Expanded(
                          child: _ButtonPaymentAccept(
                              totalPrice: order.totalPrice.toString(),
                              idOrder: order.id!)),
                      SizedBox(width: defaultPadding / 3),
                      Expanded(child: _AddFoodButton(orderModel: order))
                    ])
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [_AddFoodButton(orderModel: order)])
            ])));
  }
}

class _PriceFoodItem extends StatelessWidget {
  final FoodDto food;

  const _PriceFoodItem({required this.food});
  @override
  Widget build(BuildContext context) {
    return Text(Ultils.currencyFormat(double.parse(food.totalPrice.toString())),
        style: context.textStyleMedium!.copyWith(
            color: context.colorScheme.secondary, fontWeight: FontWeight.bold));
  }
}

class _ButtonPaymentAccept extends StatelessWidget {
  const _ButtonPaymentAccept({required this.totalPrice, required this.idOrder});
  final String totalPrice;
  final String idOrder;
  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
        style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll(context.colorScheme.primary)),
        icon: const Icon(Icons.payment_outlined, size: 15),
        label: FittedBox(
          child: Text("Thanh toán",
              style: context.textStyleLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
        ),
        onPressed: () => _handleButtonAccepted(context));
  }

  Future _handleButtonAccepted(BuildContext context) {
    final FToast fToast = FToast()..init(context);
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
            height: 200,
            child: CommonBottomSheet(
                title: "Xác nhận thanh toán?",
                textConfirm: 'Thanh toán',
                textCancel: "Hủy",
                onCancel: () {
                  context.pop();
                },
                onConfirm: () {
                  // context.read<OrderBloc>().add(PaymentOrder(idOrder: idOrder));
                  // fToast.showToast(
                  //     child:
                  //         AppAlerts.successToast(msg: 'Thanh toán thành công'));
                  context.pop();
                  context.pop();
                }));
      },
    );
  }
}

// ignore: must_be_immutable
class _AddFoodButton extends StatelessWidget {
  Orders orderModel;

  _AddFoodButton({required this.orderModel});
  @override
  Widget build(BuildContext context) {
    final FToast fToast = FToast()..init(context);
    return FilledButton.icon(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
                context.colorScheme.secondaryContainer)),
        icon: const Icon(Icons.add_box_rounded, size: 15),
        label: FittedBox(
            child: Text('Thêm món',
                style: context.textStyleLarge!
                    .copyWith(fontWeight: FontWeight.bold))),
        onPressed: () async {
          var result = await context.push(RouteName.addFood);
          if (result is FoodDto) {
            if (!checkExistFood(food: result)) {
              _handleAddFood(result);
            } else {
              fToast.showToast(
                  child: AppAlerts.errorToast(msg: 'Món ăn đã có trong đơn'));
            }
          }
        });
  }

  bool checkExistFood({FoodDto? food}) {
    var isExist = false;
    for (FoodDto e in orderModel.orderFood) {
      if (e.id == food!.id) {
        isExist = true;
        break;
      }
    }
    return isExist;
  }

  void _handleAddFood(FoodDto foodDto) {
    List<FoodDto> a = [...orderModel.orderFood, foodDto];
    orderModel = orderModel.copyWith(orderFood: a);
    logger.d(orderModel.orderFood.toString());
  }
}
