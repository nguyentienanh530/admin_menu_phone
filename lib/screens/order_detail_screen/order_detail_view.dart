import 'package:admin_menu_mobile/features/food/data/food_model.dart';
import 'package:admin_menu_mobile/features/order/bloc/order_bloc.dart';
import 'package:admin_menu_mobile/features/order/dtos/food_dto.dart';
import 'package:admin_menu_mobile/features/order/dtos/order_model.dart';
import 'package:admin_menu_mobile/utils/app_alerts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
      switch (state) {
        case OrderInProgress():
          return Center(
              child:
                  SpinKitCircle(color: context.colorScheme.primary, size: 30));

        case OrderFailure():
          return Center(child: Text(state.error!));

        case OrderSuccess():
          var order = state.orderModel as OrderModel;

          return _buildBody(context, order);

        case OrderInitial():
          return Center(
              child:
                  SpinKitCircle(color: context.colorScheme.primary, size: 30));
      }
    });
  }

  Widget _buildBody(BuildContext context, OrderModel order) {
    final FToast fToast = FToast().init(context);
    var totalPrice = double.parse(order.totalPrice.toString());
    var widget = BlocListener<OrderBloc, OrderState>(
        listenWhen: (previous, current) =>
            previous != OrderInitial() || current != OrderInitial(),
        listener: (context, state) {
          switch (state) {
            case OrderInProgress():
              Center(child: SpinKitCircle(color: context.colorScheme.primary));
              break;
            case OrderFailure():
              fToast.showToast(
                  child: AppAlerts.errorToast(context, msg: state.error));
              break;
            case OrderSuccess():
              // var mes = state.orderModel as String;
              fToast.showToast(
                  child: AppAlerts.successToast(msg: 'Xóa thành công'));
              context.pop();
              break;
            default:
          }
        },
        child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: Column(children: [
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(children: [
                Column(
                    children: order.foods!
                        .map((e) => Slidable(
                            endActionPane: ActionPane(
                                extentRatio: 0.3,
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                      borderRadius: BorderRadius.circular(
                                          defaultBorderRadius),
                                      flex: 1,
                                      // spacing: 8,
                                      padding: EdgeInsets.all(defaultPadding),
                                      onPressed: (ct) {
                                        _handleDeleteItem(context, order, e);
                                      },
                                      backgroundColor:
                                          context.colorScheme.error,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete_forever)
                                ]),
                            child: _buildItem(context, e)))
                        .toList())
              ]))),
              Card(
                  child: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Tổng tiền:",
                                  style: context.textStyleMedium),
                              Text(
                                  Ultils.currencyFormat(
                                      double.parse(totalPrice.toString())),
                                  style: context.textStyleMedium!.copyWith(
                                      color: context.colorScheme.secondary,
                                      fontWeight: FontWeight.bold))
                            ]),
                        SizedBox(height: defaultPadding),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: _ButtonAccept(
                                      totalPrice: totalPrice.toString())),
                              SizedBox(width: defaultPadding),
                              Expanded(child: _DeleteOrder(idOrder: order.id!))
                            ])
                      ])))
            ])));
    return widget;
  }

  Widget _buildItem(BuildContext context, FoodModel food) {
    var _quantity = 0;
    var _totalPrice = 0.0;
    var _lstFood = [];
    var _price = 0.0;

    _quantity = food.quantity!;

    return Card(
        child: Padding(
            padding: EdgeInsets.all(defaultPadding / 2),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          _Quantity(food: food)
                        ])
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
                    .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms))));
  }

  Widget _buildImage(FoodModel food) {
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
      BuildContext context, OrderModel orderModel, FoodModel foodModel) {
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
                  orderModel.foods!.remove(foodModel);
                  orderModel.foods!.map((e) {
                    orders.add(FoodDto().toJson(e));
                    totalPrice = totalPrice + e.totalPrice!;
                  }).toList();

                  context.read<OrderBloc>().add(DeleteFoodInOrder(
                      idOrder: orderModel.id!,
                      json: orders,
                      totalPrice: totalPrice));
                  context.pop();
                }));
      },
    );
  }
}

class _ButtonAccept extends StatelessWidget {
  const _ButtonAccept({this.totalPrice});
  final String? totalPrice;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => _handleButtonAccepted(context),
        child: Container(
            padding: EdgeInsets.all(defaultPadding),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: context.colorScheme.primary,
                borderRadius: BorderRadius.circular(defaultBorderRadius)),
            child: Text("Thanh toán",
                style: context.textStyleMedium!
                    .copyWith(fontWeight: FontWeight.bold))));
  }

  Future _handleButtonAccepted(BuildContext context) {
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
                  // var orders = <Map<String, dynamic>>[];
                  // var totalPrice = 0.0;
                  // orderModel.foods!.remove(foodModel);
                  // orderModel.foods!.map((e) {
                  //   orders.add(FoodDto().toJson(e));
                  //   totalPrice = totalPrice + e.totalPrice!;
                  // }).toList();

                  // context.read<OrderBloc>().add(DeleteFoodInOrder(
                  //     idOrder: orderModel.id!,
                  //     json: orders,
                  //     totalPrice: totalPrice));
                  context.pop();
                }));
      },
    );
    // Get.bottomSheet(SizedBox(
    //     height: 200,
    //     child: BottomSheetDelete(
    //         title: "Kiểm tra kĩ trước khi thanh toán",
    //         textConfirm: 'Xác nhận',
    //         textCancel: "Hủy",
    //         textConfirmColor: greenheighlightColor,
    //         onCancel: () {
    //           Get.back();
    //         },
    //         onConfirm: () {
    //           firebase.update({
    //             "isPay": true,
    //             "datePay": DateTime.now().toString()
    //           }).then((value) => AwesomeDialog(
    //               btnOkText: "Xác nhận",
    //               context: context,
    //               dialogType: DialogType.success,
    //               animType: AnimType.rightSlide,
    //               title: 'Thành công',
    //               desc: 'Đơn hàng đã được thanh toán',
    //               btnOkOnPress: () {
    //                 Navigator.pop(context);
    //                 Get.back();
    //                 // Navigator.of(context).pushAndRemoveUntil(
    //                 //     MaterialPageRoute(
    //                 //         builder: (context) => const HomeScreen()),
    //                 //     (route) => false);
    //               }).show());
    //         })));
  }
}

class _DeleteOrder extends StatelessWidget {
  final String idOrder;

  const _DeleteOrder({required this.idOrder});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => _handleDeleteOrder(context, idOrder),
        child: Container(
            padding: EdgeInsets.all(defaultPadding),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: context.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(defaultBorderRadius)),
            child: Text('Xóa đơn',
                style: context.textStyleMedium!
                    .copyWith(fontWeight: FontWeight.bold))));
  }

  Future _handleDeleteOrder(BuildContext context, String idOrder) {
    return showModalBottomSheet<void>(
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
                  context.read<OrderBloc>().add(DeleteOrder(idOrder: idOrder));
                  context.pop();
                }));
      },
    );
  }
}

class _Quantity extends StatelessWidget {
  final FoodModel food;

  const _Quantity({required this.food});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      // LineText(title: "Số lượng: ", value: food.quantity.toString()),
      InkWell(
          onTap: () {
            _handleDecrement();
          },
          child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: context.colorScheme.secondary),
              child: const Icon(Icons.remove, size: 20))),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(food.quantity.toString(), style: context.textStyleSmall)),
      InkWell(
          onTap: () {
            _handleIncrement();
          },
          child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: context.colorScheme.secondary),
              child: const Icon(Icons.add, size: 20)))
    ]);
  }

  void _handleDecrement() {
    // if (_quantity.value > 1) {
    //   _quantity.value--;
    //   _price = 0;
    //   _totalPrice.value =
    //       double.parse(food.price.toString()) *
    //           _quantity.value;

    //   _.lstOrderFood.value.foods!
    //       .forEach((element) {
    //     if (element.id == food.id) {
    //       element.quantity = _quantity.value;
    //       element.totalPrice = _totalPrice.value;
    //     }
    //     _lstFood.add(Food().toJson(element));
    //   });
    //   _lstFood.forEach((element) {
    //     _price = _price + element['totalPrice'];
    //   });
    //   _.totalPriceBill.value = _price;
    //   _.updateOrder(
    //       idOrder: idOrder,
    //       lstFood: _lstFood,
    //       totalPriceBill: _.totalPriceBill.value);
    //   _lstFood.clear();
    // }
  }

  void _handleIncrement() {
    // _price = 0;
    // _quantity.value++;
    // _totalPrice.value =
    //     double.parse(food.price.toString()) *
    //         _quantity.value;
    // _.lstOrderFood.value.foods!.forEach((element) {
    //   // orderCtrl.totalPriceBill.value = 0.0;
    //   if (element.id == food.id) {
    //     element.quantity = _quantity.value;
    //     element.totalPrice = _totalPrice.value;
    //   }
    //   _lstFood.add(Food().toJson(element));
    // });
    // _lstFood.forEach((element) {
    //   _price = _price + element['totalPrice'];
    // });
    // _.totalPriceBill.value = _price;
    // _.updateOrder(
    //     idOrder: idOrder,
    //     lstFood: _lstFood,
    //     totalPriceBill: _.totalPriceBill.value);
    // _lstFood.clear();
  }
}
