import 'package:admin_menu_mobile/common/bloc/bloc_helper.dart';
import 'package:admin_menu_mobile/common/bloc/generic_bloc_state.dart';
import 'package:admin_menu_mobile/common/dialog/progress_dialog.dart';
import 'package:admin_menu_mobile/common/dialog/retry_dialog.dart';
import 'package:admin_menu_mobile/features/order/data/model/order_model.dart';
import 'package:admin_menu_mobile/core/utils/utils.dart';
import 'package:admin_menu_mobile/features/order/data/provider/remote/order_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:admin_menu_mobile/features/order/data/model/food_dto.dart';
import 'package:admin_menu_mobile/common/dialog/app_alerts.dart';
import 'package:order_repository/order_repository.dart';
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
        create: (context) => OrderBloc(),
        child: Scaffold(
            appBar: _buildAppbar(context),
            body: OrderDetailView(orders: orders)));
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        title: Text(orders.id!, style: context.titleStyleMedium),
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
            label: const FittedBox(child: Text('Xóa đơn')),
            onPressed: () => _handleDeleteOrder(context, idOrder)));
  }

  void _handleDeleteOrder(BuildContext context, String idOrder) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return CommonBottomSheet(
              title: "Bạn có muốn xóa đơn này không?",
              textConfirm: 'Xóa',
              textCancel: "Hủy",
              textConfirmColor: context.colorScheme.errorContainer,
              onConfirm: () {
                context.read<OrderBloc>().add(OrderDeleted(orderID: idOrder));
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
                                          .add(OrderDeleted(orderID: idOrder))),
                                  Status.success => ProgressDialog(
                                      descriptrion: "Xóa thành công!",
                                      isProgressed: false,
                                      onPressed: () => pop(context, 3))
                                }));
              });
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
  final _totalPrice = ValueNotifier<num>(0.0);

  @override
  void initState() {
    orders = widget.orders;
    _totalPrice.value = orders.totalPrice ?? 0.0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context, orders);
  }

  Widget _buildBody(BuildContext context, Orders order) {
    return BlocListener<OrderBloc, GenericBlocState<Orders>>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            context.read<OrderBloc>().operation == ApiOperation.update,
        listener: (context, state) => (switch (state.status) {
              Status.loading => AppAlerts.loadingDialog(context),
              Status.empty => const SizedBox(),
              Status.failure => AppAlerts.failureDialog(context,
                    desc: state.error, btnOkOnPress: () {
                  context.pop();
                }),
              Status.success =>
                AppAlerts.successDialog(context, btnOkOnPress: () {
                  pop(context, 3);
                })
            }),
        child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: Column(children: [
              Expanded(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: orders.foods.length,
                      itemBuilder: (context, index) =>
                          _buildItemFood(orders.foods[index])
                              .animate()
                              .slideX(
                                  begin: -0.1,
                                  end: 0,
                                  curve: Curves.easeInOutCubic,
                                  duration: 500.ms)
                              .fadeIn(
                                  curve: Curves.easeInOutCubic,
                                  duration: 500.ms))),
              _buildBottomAction()
            ])));
  }

  Widget _buildItemFood(FoodDto foodDto) {
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
                        _handleDeleteItem(foodDto);
                      },
                      backgroundColor: context.colorScheme.error,
                      foregroundColor: Colors.white,
                      icon: Icons.delete_forever)
                ]),
            child: _buildItem(foodDto)));
  }

  Widget _buildItem(FoodDto foodDto) {
    // final foodDtoo = ValueNotifier(foodDto);

    final quantity = ValueNotifier(foodDto.quantity);
    final totalPriceFood = ValueNotifier(foodDto.totalPrice);
    return ItemFood(
        totalPriceFood: totalPriceFood,
        quantity: quantity,
        foodDto: foodDto,
        onTapIncrement: () {
          quantity.value++;
          totalPriceFood.value = quantity.value * foodDto.foodPrice;
          _handleUpdate(foodDto, quantity.value);
        },
        onTapDecrement: () {
          if (quantity.value > 1) {
            quantity.value--;
            totalPriceFood.value = quantity.value * foodDto.foodPrice;
            _handleUpdate(foodDto, quantity.value);
          }
        });
  }

  void _handleUpdate(FoodDto foodDto, int quantity) {
    foodDto = foodDto.copyWith(
        quantity: quantity, totalPrice: quantity * foodDto.foodPrice);
    orders = orders.copyWith(
        foods: orders.foods.map((element) {
      if (element.foodID == foodDto.foodID) {
        return element.copyWith(
            quantity: foodDto.quantity, totalPrice: foodDto.totalPrice);
      }
      return element;
    }).toList());
    _totalPrice.value = 0;
    for (FoodDto foo in orders.foods) {
      _totalPrice.value += foo.totalPrice;
    }
    orders = orders.copyWith(totalPrice: _totalPrice.value);
    OrderRepo(
            orderRepository:
                OrderRepository(firebaseFirestore: FirebaseFirestore.instance))
        .updateOrder(orders: orders);
    // context.read<OrderBloc>().add(OrderUpdated(orders: orders));
  }

  void _handleDeleteItem(FoodDto foodDto) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
              height: 200,
              child: CommonBottomSheet(
                  title: "Bạn có muốn xóa món ăn này không?",
                  textConfirm: 'Xóa',
                  textCancel: "Hủy",
                  textConfirmColor: context.colorScheme.errorContainer,
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
                      orders =
                          orders.copyWith(foods: foods, totalPrice: totalPrice);
                    });

                    context.read<OrderBloc>().add(OrderUpdated(orders: orders));
                    context.pop();
                  }));
        }).then((value) => _totalPrice.value = orders.totalPrice!);
  }

  Widget _buildBottomAction() {
    return Card(
        child: Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("Tổng tiền:"),
                ValueListenableBuilder(
                    valueListenable: _totalPrice,
                    builder: (context, value, child) => Text(
                        Ultils.currencyFormat(double.parse(value.toString())),
                        style: TextStyle(
                            color: context.colorScheme.secondary,
                            fontWeight: FontWeight.bold)))
              ]),
              SizedBox(height: defaultPadding),
              orders.foods.isNotEmpty
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Expanded(child: _buildPaymentAccepted()),
                      SizedBox(width: defaultPadding / 3),
                      Expanded(child: _buildButtonAddFood())
                    ])
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [_buildButtonAddFood()])
            ])));
  }

  Widget _buildPaymentAccepted() {
    return FilledButton.icon(
        style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll(context.colorScheme.primary)),
        icon: const Icon(Icons.payment_outlined, size: 15),
        label: FittedBox(
          child: Text("Thanh toán", style: context.titleStyleMedium),
        ),
        onPressed: () => _handleButtonAccepted(context));
  }

  Future<void> _handleButtonAccepted(BuildContext context) async {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return BlocProvider(
              create: (context) => OrderBloc()..add(NewOrdersFecthed()),
              child: BlocBuilder<OrderBloc, GenericBlocState<Orders>>(
                  builder: (context, state) {
                if (state.status == Status.success) {
                  return CommonBottomSheet(
                      title: "Xác nhận thanh toán?",
                      textConfirm: 'Thanh toán',
                      textCancel: "Hủy",
                      onConfirm: () {
                        context.pop();
                        handlePaymentSubmited();
                        if (state.datas!.length <= 1) {
                          FirebaseFirestore.instance
                              .collection('table')
                              .doc(orders.tableID)
                              .update({'isUse': false});
                        }
                      });
                }
                return const Center(child: Text('Có lỗi xảy ra!'));
              }));
        });
  }

  void handlePaymentSubmited() {
    context.read<OrderBloc>().add(OrderPaymented(orderID: orders.id!));
  }

  Widget _buildButtonAddFood() {
    final FToast fToast = FToast()..init(context);
    return FilledButton.icon(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
                context.colorScheme.secondaryContainer)),
        icon: const Icon(Icons.add_box_rounded, size: 15),
        label:
            FittedBox(child: Text('Thêm món', style: context.titleStyleMedium)),
        onPressed: () async {
          await context.push(RouteName.addFood).then((result) {
            if (result is FoodDto) {
              if (!checkExistFood(food: result)) {
                _handleAddFood(result);
                // context
                //     .read<FoodBloc>()
                //     .add(GetFoodByID(foodID: result.foodID));
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

    // logger.d(orders.toString());
    // context.read<OrderBloc>().add(OrderUpdated(orders: orders));
    OrderRepo(
            orderRepository:
                OrderRepository(firebaseFirestore: FirebaseFirestore.instance))
        .updateOrder(orders: orders);
  }
}

class _PriceFoodItem extends StatelessWidget {
  final String totalPrice;

  const _PriceFoodItem({required this.totalPrice});
  // food.totalPrice.toString()
  @override
  Widget build(BuildContext context) {
    return Text(Ultils.currencyFormat(double.parse(totalPrice)),
        style: TextStyle(
            color: context.colorScheme.secondary, fontWeight: FontWeight.bold));
  }
}

class ItemFood extends StatelessWidget {
  const ItemFood(
      {super.key,
      required this.quantity,
      required this.totalPriceFood,
      required this.foodDto,
      required this.onTapIncrement,
      required this.onTapDecrement});
  final FoodDto foodDto;
  final ValueNotifier<int> quantity;
  final ValueNotifier<num> totalPriceFood;
  final void Function()? onTapIncrement;
  final void Function()? onTapDecrement;
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              _buildImage(foodDto),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(),
                Text(foodDto.foodName),
                SizedBox(height: defaultPadding / 2),
                _buildQuality(context, foodDto)
              ])
            ]),
            Padding(
                padding: EdgeInsets.only(right: defaultPadding / 2),
                child: ValueListenableBuilder(
                    valueListenable: totalPriceFood,
                    builder: (context, value, child) =>
                        _PriceFoodItem(totalPrice: value.toString())))
          ]),
          foodDto.note.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        const Text("Ghi chú: "),
                        Text(foodDto.note,
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.3)))
                      ]))
              : const SizedBox()
        ]));
  }

  Widget _buildQuality(BuildContext context, FoodDto foodDto) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      // LineText(title: "Số lượng: ", value: food.quantity.toString()),
      InkWell(
          onTap: onTapDecrement,
          child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: context.colorScheme.secondary),
              child: const Icon(Icons.remove, size: 20))),
      ValueListenableBuilder(
          valueListenable: quantity,
          builder: (context, value, child) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text('$value'))),
      InkWell(
          onTap: onTapIncrement,
          child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: context.colorScheme.secondary),
              child: const Icon(Icons.add, size: 20)))
    ]);
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
                image: NetworkImage(
                    food.foodImage == "" ? noImage : food.foodImage),
                fit: BoxFit.cover)));
  }
}
