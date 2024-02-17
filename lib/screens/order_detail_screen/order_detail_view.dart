import 'package:admin_menu_mobile/features/food/data/food_model.dart';
import 'package:admin_menu_mobile/features/order/bloc/order_bloc.dart';
import 'package:admin_menu_mobile/features/order/data/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        switch (state) {
          case OrderInProgress():
            return Center(
                child: SpinKitCircle(
                    color: context.colorScheme.primary, size: 30));

          case OrderFailure():
            return Center(child: Text(state.error!));

          case OrderSuccess():
            var order = state.orderModel as OrderModel;

            return _buildBody(context, order);

          case OrderInitial():
            return Center(
                child: SpinKitCircle(
                    color: context.colorScheme.primary, size: 30));
        }
      },
    );
  }

  Widget _buildBody(BuildContext context, OrderModel order) {
    return Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        child: Column(children: [
          Expanded(
              child: SingleChildScrollView(
                  child: Column(children: [
            Column(
                children: order.foods!
                    .map((e) => Slidable(
                        child: _buildItem(context, e),
                        endActionPane: ActionPane(
                            extentRatio: 0.3,
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                  flex: 1,
                                  spacing: 1,
                                  padding: EdgeInsets.all(defaultPadding),
                                  onPressed: (ct) {
                                    // var _price = 0.0;
                                    // var _lstFood = [];
                                    // Get.bottomSheet(SizedBox(
                                    //     height: 200,
                                    //     child: BottomSheetDelete(
                                    //         title: "Xóa món '${e.title}' ?",
                                    //         textConfirm: 'Xóa',
                                    //         textCancel: "Hủy",
                                    //         onCancel: () {
                                    //           Get.back();
                                    //         },
                                    //         onConfirm: () {
                                    //           _price = 0.0;
                                    //           _.lstOrderFood.value.foods!
                                    //               .remove(e);
                                    //           _.lstOrderFood.value.foods!
                                    //               .forEach((element) {
                                    //             _lstFood.add(
                                    //                 Food().toJson(element));
                                    //           });
                                    //           _lstFood.forEach((element) {
                                    //             _price = _price +
                                    //                 element['totalPrice'];
                                    //           });
                                    //           _.totalPriceBill.value = _price;

                                    //           FirebaseFirestore.instance
                                    //               .collection('AllOrder')
                                    //               .doc(idOrder)
                                    //               .update({
                                    //             'order_food': _lstFood,
                                    //             'totalPrice':
                                    //                 _.totalPriceBill.value
                                    //           }).then((value) {
                                    //             _lstFood.clear();
                                    //             Get.back();
                                    //             return Get.snackbar("Thông báo",
                                    //                 "Đã xóa món: ${e.title}",
                                    //                 duration: const Duration(
                                    //                     seconds: 2),
                                    //                 snackPosition:
                                    //                     SnackPosition.TOP);
                                    //           }).onError((error, stackTrace) =>
                                    //                   Get.snackbar("Thông báo",
                                    //                       "Lỗi xóa đơn: $error",
                                    //                       duration:
                                    //                           const Duration(
                                    //                               seconds: 2),
                                    //                       snackPosition:
                                    //                           SnackPosition
                                    //                               .TOP));
                                    //         })));
                                  },
                                  backgroundColor: context.colorScheme.error,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete_forever)
                            ])))
                    .toList())
          ]))),
          _buildButtonAccept(context, '12312312312', () {
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
          })
        ]));
  }

  Widget _buildButtonAccept(
      BuildContext context, String totalPrice, Function() onTap) {
    return Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        height: 150,
        child: Column(children: [
          const SizedBox(height: 10),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tổng tiền:", style: context.textStyleSmall),
                    Text(Ultils.currencyFormat(double.parse(totalPrice)),
                        style: context.textStyleMedium!.copyWith(
                            color: context.colorScheme.secondary,
                            fontWeight: FontWeight.bold))
                  ])),
          const SizedBox(height: 10),
          InkWell(
              onTap: onTap,
              child: Container(
                  height: 55.0,
                  width: MediaQuery.of(context).size.width / 1.15,
                  decoration: BoxDecoration(
                      color: context.colorScheme.primary,
                      borderRadius: BorderRadius.circular(defaultBorderRadius)),
                  child: Center(
                      child: Text("Thanh toán",
                          style: context.textStyleMedium!
                              .copyWith(fontWeight: FontWeight.bold))))),
          const SizedBox(height: 10)
        ]));
  }

  Widget _buildItem(BuildContext context, FoodModel food) {
    var _quantity = 0;
    var _totalPrice = 0.0;
    var _lstFood = [];
    var _price = 0.0;
    _totalPrice = double.parse(food.totalPrice.toString());
    _quantity = food.quantity!;

    return Card(
      child: SizedBox(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          _buildImage(food),
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(),
                Text(food.title!, style: context.textStyleSmall),
                // CommonLineText(title: "Món: ", value: food.title),

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // LineText(title: "Số lượng: ", value: food.quantity.toString()),
                      InkWell(
                          onTap: () {
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
                          },
                          child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: context.colorScheme.secondary),
                              child: const Icon(Icons.remove, size: 20))),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text('100', style: context.textStyleSmall)),
                      InkWell(
                          onTap: () {
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
                          },
                          child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: context.colorScheme.secondary),
                              child: const Icon(Icons.add, size: 20)))
                    ]),
                Text("Ghi chú: ", style: context.textStyleSmall),
                // FittedBox(
                //     child: Text(food.note!, style: context.textStyleSmall)),
                // CommonLineText(title: "Ghi chú: ", value: food.note),
              ])
        ]),
        // Padding(
        //   padding: EdgeInsets.only(right: defaultPadding),
        //   child: LineText(
        //       color: lightAccent,
        //       value: Constant.currencyFormat(
        //           double.parse(_totalPrice.value.toString()))),
        // )
      ])),
    );
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
}
