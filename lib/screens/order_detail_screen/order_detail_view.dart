import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:admin_menu_mobile/features/food/model/food_model.dart';
import 'package:admin_menu_mobile/features/order/bloc/order_bloc.dart';
import 'package:admin_menu_mobile/features/order/dtos/food_dto.dart';
import 'package:admin_menu_mobile/features/order/dtos/order_model.dart';
import 'package:admin_menu_mobile/utils/app_alerts.dart';
import 'package:admin_menu_mobile/widgets/empty_screen.dart';
import '../../config/router.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
      var loadingOrInit = Center(
          child: SpinKitCircle(color: context.colorScheme.primary, size: 30));
      return (switch (state.status) {
        OrderStatus.loading => loadingOrInit,
        OrderStatus.failure => Center(child: Text(state.message)),
        OrderStatus.success => _buildBody(context, state.order),
        OrderStatus.initial => loadingOrInit
      });
    });
  }

  Widget _buildBody(BuildContext context, OrderModel order) {
    return Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        child: Column(children: [
          Expanded(
              child: order.orderFood!.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(children: [
                      Column(
                          children: order.orderFood!
                              .map((e) => _ItemFood(orderModel: order, food: e))
                              .toList())
                    ]))
                  : const EmptyScreen()),
          _BottomAction(order: order)
        ]));
  }
}

class _ItemFood extends StatelessWidget {
  final OrderModel orderModel;
  final Food food;
  const _ItemFood({required this.orderModel, required this.food});
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
                        _handleDeleteItem(context, orderModel, food);
                      },
                      backgroundColor: context.colorScheme.error,
                      foregroundColor: Colors.white,
                      icon: Icons.delete_forever)
                ]),
            child: _buildItem(context, food, orderModel)));
  }

  Widget _buildItem(BuildContext context, Food food, OrderModel orderModel) {
    return Card(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  _buildImage(food),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(),
                        Text(food.title!,
                            style: context.textStyleMedium!
                                .copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(height: defaultPadding / 2),
                        _Quantity(food: food, orderModel: orderModel)
                      ])
                ]),
                Padding(
                  padding: EdgeInsets.only(right: defaultPadding / 2),
                  child: _PriceFoodItem(food: food),
                ),
              ]),
              food.note!.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Text("Ghi chú: ",
                              style: context.textStyleMedium!
                                  .copyWith(fontWeight: FontWeight.bold)),
                          Text(food.note!, style: context.textStyleSmall)
                        ])
                  : const SizedBox()
            ]
                .animate(interval: 50.ms)
                .slideX(
                    begin: -0.1,
                    end: 0,
                    curve: Curves.easeInOutCubic,
                    duration: 500.ms)
                .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms)));
  }

  Widget _buildImage(Food food) {
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
      BuildContext context, OrderModel orderModel, Food food) {
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
                    orderModel.orderFood!.remove(food);
                    orderModel.orderFood!.map((e) {
                      orders.add(FoodDto().toJson(e));
                      totalPrice = totalPrice + e.totalPrice;
                    }).toList();

                    context.read<OrderBloc>().add(UpdateFoodInOrder(
                        idOrder: orderModel.id!,
                        json: orders,
                        totalPrice: totalPrice));
                    context.pop();
                  }));
        });
  }
}

class _BottomAction extends StatelessWidget {
  final OrderModel order;

  const _BottomAction({required this.order});
  @override
  Widget build(BuildContext context) {
    var totalPrice = double.parse(order.totalPrice.toString());
    return Card(
        child: Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Tổng tiền:", style: context.textStyleMedium),
                Text(Ultils.currencyFormat(double.parse(totalPrice.toString())),
                    style: context.textStyleMedium!.copyWith(
                        color: context.colorScheme.secondary,
                        fontWeight: FontWeight.bold))
              ]),
              SizedBox(height: defaultPadding),
              order.orderFood!.isNotEmpty
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Expanded(
                          child: _ButtonPaymentAccept(
                              totalPrice: totalPrice.toString(),
                              idOrder: order.id!)),
                      SizedBox(width: defaultPadding / 3),
                      Expanded(child: _AddFoodButton(orderModel: order))
                    ])
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _AddFoodButton(orderModel: order),
                      ],
                    )
            ])));
  }
}

class _PriceFoodItem extends StatelessWidget {
  final Food food;

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
                  context.read<OrderBloc>().add(PaymentOrder(idOrder: idOrder));
                  fToast.showToast(
                      child:
                          AppAlerts.successToast(msg: 'Thanh toán thành công'));
                  context.pop();
                  context.pop();
                }));
      },
    );
  }
}

class _AddFoodButton extends StatelessWidget {
  final OrderModel orderModel;

  const _AddFoodButton({required this.orderModel});
  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
                context.colorScheme.secondaryContainer)),
        icon: const Icon(Icons.add_box_rounded, size: 15),
        label: FittedBox(
            child: Text('Thêm món',
                style: context.textStyleLarge!
                    .copyWith(fontWeight: FontWeight.bold))),
        onPressed: () => _handleAddFood(context));
  }

  bool checkExistFood({Food? food}) {
    var isExist = false;
    for (Food e in orderModel.orderFood!) {
      if (e.id == food!.id) {
        isExist = true;
        break;
      }
    }
    return isExist;
  }

  void _handleAddFood(BuildContext context) async {
    final FToast fToast = FToast()..init(context);
    var lstFood = <Map<String, dynamic>>[];
    var totalBill = 0.0;
    context.push(RouteName.addFood).then((food) {
      if (food is Food) {
        var newFood = food;
        if (!checkExistFood(food: food)) {
          orderModel.orderFood!.add(newFood);
          lstFood.addAll(orderModel.orderFood!.map((e) {
            totalBill = totalBill + e.totalPrice;
            return FoodDto().toJson(e);
          }).toList());

          context.read<OrderBloc>().add(UpdateFoodInOrder(
              idOrder: orderModel.id!, json: lstFood, totalPrice: totalBill));
        } else {
          fToast.showToast(
              child:
                  AppAlerts.errorToast(context, msg: 'Món ăn đã có trong đơn'));
        }
      }
    });
  }
}

// ignore: must_be_immutable
class _Quantity extends StatelessWidget {
  Food food;
  final OrderModel orderModel;
  _Quantity({required this.food, required this.orderModel});
  @override
  Widget build(BuildContext context) {
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
          child: Text('${food.quantity}',
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
    if (food.quantity > 1) {
      var totalBill = 0.0;
      var orders = <Map<String, dynamic>>[];
      food = food.copyWith(
          quantity: food.quantity - 1, totalPrice: food.quantity * food.price!);
      // for (var element in orderModel.foods!) {
      //   if (element.id == food.id) {
      //     element.quantity = element.quantity - 1;
      //     element.totalPrice = element.quantity * food.price!;
      //   }
      // }
      for (var element in orderModel.orderFood!) {
        orders.add(FoodDto().toJson(element));
        totalBill = totalBill + element.totalPrice;
      }
      context.read<OrderBloc>().add(UpdateFoodInOrder(
          idOrder: orderModel.id!, json: orders, totalPrice: totalBill));
    }
  }

  void _handleIncrement(BuildContext context) {
    var totalBill = 0.0;
    var orders = <Map<String, dynamic>>[];
    food = food.copyWith(
        quantity: food.quantity - 1, totalPrice: food.quantity * food.price!);
    // for (var element in orderModel.foods!) {
    //   if (element.id == food.id) {
    //     element.quantity = element.quantity! + 1;
    //     element.totalPrice = element.quantity! * food.price!;
    //   }
    // }
    for (var element in orderModel.orderFood!) {
      orders.add(FoodDto().toJson(element));
      totalBill = totalBill + element.totalPrice;
    }
    context.read<OrderBloc>().add(UpdateFoodInOrder(
        idOrder: orderModel.id!, json: orders, totalPrice: totalBill));
  }
}
