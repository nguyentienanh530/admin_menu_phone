import 'package:admin_menu_mobile/common/bloc/generic_bloc_state.dart';
import 'package:admin_menu_mobile/common/dialog/progress_dialog.dart';
import 'package:admin_menu_mobile/common/dialog/retry_dialog.dart';
import 'package:admin_menu_mobile/features/food/bloc/food_bloc.dart';
import 'package:admin_menu_mobile/features/food/data/model/food_model.dart';
import 'package:admin_menu_mobile/features/order/cubit/total_price_cubit.dart';
import 'package:admin_menu_mobile/features/order/data/model/order_model.dart';
import 'package:admin_menu_mobile/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:admin_menu_mobile/features/order/data/model/food_dto.dart';
import 'package:admin_menu_mobile/common/dialog/app_alerts.dart';
import '../../../../common/widget/common_bottomsheet.dart';
import '../../../../config/router.dart';
import '../../bloc/order_bloc.dart';

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
                    context
                        .read<OrderBloc>()
                        .add(OrderDeleted(orderID: idOrder));
                    showDialog(
                        context: context,
                        builder: (context) => BlocBuilder<OrderBloc,
                                GenericBlocState<Orders>>(
                            builder: (context, state) => switch (state.status) {
                                  Status.loading => const ProgressDialog(
                                      descriptrion: "Đang xóa...",
                                      isProgressed: true),
                                  Status.empty => const SizedBox(),
                                  Status.failure => RetryDialog(
                                      title: 'Lỗi',
                                      onRetryPressed: () => context
                                          .read<OrderBloc>()
                                          .add(OrderDeleted(orderID: idOrder))),
                                  Status.success => ProgressDialog(
                                      descriptrion: "Xóa thành công!",
                                      isProgressed: false,
                                      onPressed: () => pop(context, 2))
                                }));
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

// ignore: must_be_immutable
class OrderDetailView extends StatefulWidget {
  OrderDetailView({super.key, required this.orders});
  Orders orders;
  @override
  State<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  var orders = Orders();

  @override
  void initState() {
    orders = widget.orders;
    context.read<TotalPriceCubit>().onTotalPriceChanged(orders.totalPrice!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                children: order.foods
                    .map((e) => _buildItemFood(e))
                    .toList()
                    .animate(interval: 50.ms)
                    .slideX(
                        begin: -0.1,
                        end: 0,
                        curve: Curves.easeInOutCubic,
                        duration: 500.ms)
                    .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms))
          ]))),
          _buildBottomAction()
        ]));
  }

  Widget _buildItemFood(FoodDto foo) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
        child: BlocProvider(
            create: (context) =>
                FoodBloc()..add(GetFoodByID(foodID: foo.foodID)),
            child: BlocBuilder<FoodBloc, GenericBlocState<Food>>(
                buildWhen: (previous, current) =>
                    current.status == Status.success,
                builder: (context, state) {
                  return Slidable(
                      endActionPane: ActionPane(
                          extentRatio: 0.3,
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                                borderRadius:
                                    BorderRadius.circular(defaultBorderRadius),
                                flex: 1,
                                // spacing: 8,
                                padding: EdgeInsets.all(defaultPadding),
                                onPressed: (ct) {
                                  _handleDeleteItem(foo);
                                },
                                backgroundColor: context.colorScheme.error,
                                foregroundColor: Colors.white,
                                icon: Icons.delete_forever)
                          ]),
                      child: _buildItem(state.data ?? Food(), foo));
                })));
  }

  Widget _buildItem(Food food, FoodDto foodDto) {
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
                Text(food.name,
                    style: context.textStyleMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: defaultPadding / 2),
                _buildQuality(food, foodDto)
              ])
            ]),
            Padding(
                padding: EdgeInsets.only(right: defaultPadding / 2),
                child:
                    _PriceFoodItem(totalPrice: (foodDto.totalPrice).toString()))
          ]),
          foodDto.note.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        Text("Ghi chú: ",
                            style: context.textStyleMedium!
                                .copyWith(fontWeight: FontWeight.bold)),
                        Text(foodDto.note, style: context.textStyleSmall)
                      ]),
                )
              : const SizedBox()
        ]));
  }

  void _handleDeleteItem(FoodDto foodDto) {
    showModalBottomSheet<void>(
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
                        var foods = <FoodDto>[];
                        foods.addAll(orders.foods);
                        var totalPrice = 0.0;
                        foods.removeWhere(
                            (element) => element.foodID == foodDto.foodID);

                        for (FoodDto foo in foods) {
                          totalPrice += foo.totalPrice;
                        }
                        setState(() {
                          orders = orders.copyWith(
                              foods: foods, totalPrice: totalPrice);
                        });

                        context
                            .read<OrderBloc>()
                            .add(OrderUpdated(orders: orders));
                        context.pop();
                      }));
            })
        .then((value) => context
            .read<TotalPriceCubit>()
            .onTotalPriceChanged(orders.totalPrice!));
  }

  Widget _buildQuality(Food food, FoodDto foodDto) {
    var quantity = foodDto.quantity;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      // LineText(title: "Số lượng: ", value: food.quantity.toString()),
      InkWell(
          onTap: () => _handleDecrement(food, foodDto, quantity),
          child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: context.colorScheme.secondary),
              child: const Icon(Icons.remove, size: 20))),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text('$quantity',
              style: context.textStyleSmall!
                  .copyWith(fontWeight: FontWeight.bold))),
      InkWell(
          onTap: () => _handleIncrement(food, foodDto, quantity),
          child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: context.colorScheme.secondary),
              child: const Icon(Icons.add, size: 20)))
    ]);
  }

  void _handleDecrement(Food food, FoodDto foodDto, int quantity) {
    if (quantity > 1) {
      setState(() {
        quantity = quantity - 1;
      });
      foodDto = foodDto.copyWith(
          quantity: quantity, totalPrice: quantity * food.price);

      orders = orders.copyWith(
          foods: orders.foods.map((element) {
        if (element.foodID == foodDto.foodID) {
          return element.copyWith(
              quantity: foodDto.quantity, totalPrice: foodDto.totalPrice);
        }
        return element;
      }).toList());
      var totalprice = 0.0;
      for (FoodDto foo in orders.foods) {
        totalprice += foo.totalPrice;
      }
      orders = orders.copyWith(totalPrice: totalprice);
      context.read<TotalPriceCubit>().onTotalPriceChanged(totalprice);
      context.read<OrderBloc>().add(OrderUpdated(orders: orders));
    }
  }

  void _handleIncrement(Food food, FoodDto foodDto, int quantity) {
    setState(() {
      quantity++;
    });
    foodDto =
        foodDto.copyWith(quantity: quantity, totalPrice: quantity * food.price);

    orders = orders.copyWith(
        foods: orders.foods.map((element) {
      if (element.foodID == foodDto.foodID) {
        return element.copyWith(
            quantity: foodDto.quantity, totalPrice: foodDto.totalPrice);
      }
      return element;
    }).toList());

    var totalprice = 0.0;

    for (FoodDto foo in orders.foods) {
      totalprice += foo.totalPrice;
    }
    orders = orders.copyWith(totalPrice: totalprice);
    context.read<TotalPriceCubit>().onTotalPriceChanged(totalprice);
    context.read<OrderBloc>().add(OrderUpdated(orders: orders));
    // context.read<OrderBloc>().add(GetOrdersByID(orderID: orderModel.id!));
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
                image: NetworkImage(food.image == "" ? noImage : food.image),
                fit: BoxFit.cover)));
  }

  Widget _buildBottomAction() {
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
              orders.foods.isNotEmpty
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Expanded(
                          child: _ButtonPaymentAccept(
                              totalPrice: orders.totalPrice.toString(),
                              idOrder: orders.id!)),
                      SizedBox(width: defaultPadding / 3),
                      Expanded(child: _buildButtonAddFood())
                    ])
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [_buildButtonAddFood()])
            ])));
  }

  Widget _buildButtonAddFood() {
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
          await context.push(RouteName.addFood).then((result) {
            if (result is FoodDto) {
              if (!checkExistFood(food: result)) {
                _handleAddFood(result);
                context
                    .read<FoodBloc>()
                    .add(GetFoodByID(foodID: result.foodID));
              } else {
                fToast.showToast(
                    child: AppAlerts.errorToast(msg: 'Món ăn đã có trong đơn'));
              }
            }
            return setState(() {});
          });
        });
  }

  bool checkExistFood({FoodDto? food}) {
    var isExist = false;
    for (FoodDto e in orders.foods) {
      if (e.foodID == food!.foodID) {
        isExist = true;
        break;
      }
    }
    return isExist;
  }

  void _handleAddFood(FoodDto foodDto) {
    List<FoodDto> foods = [...orders.foods, foodDto];

    var totalPrice = 0.0;
    for (FoodDto foo in foods) {
      totalPrice += foo.totalPrice;
    }
    orders = orders.copyWith(foods: foods, totalPrice: totalPrice);

    logger.d(orders.toString());
    context.read<OrderBloc>().add(OrderUpdated(orders: orders));
  }
}

class _PriceFoodItem extends StatelessWidget {
  final String totalPrice;

  const _PriceFoodItem({required this.totalPrice});
  // food.totalPrice.toString()
  @override
  Widget build(BuildContext context) {
    return Text(Ultils.currencyFormat(double.parse(totalPrice)),
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
                    pop(context, 2);
                  }));
        });
  }
}
