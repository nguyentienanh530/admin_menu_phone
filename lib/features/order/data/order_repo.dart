import 'package:admin_menu_mobile/common/firebase/firebase_base.dart';
import 'package:admin_menu_mobile/common/firebase/firebase_result.dart';
import 'package:order_repository/order_repository.dart';
import '../dtos/order_model.dart';

class OrderRepo extends FirebaseBase<Orders> {
  final OrderRepository _orderRepository;

  OrderRepo({required OrderRepository orderRepository})
      : _orderRepository = orderRepository;

  Stream<FirebaseResult<List<Orders>>> getOrderOnTable({String? nameTable}) {
    return getItemsOnStream(
        _orderRepository.getOrderOnTable(nameTable: nameTable),
        (json) => Orders.fromJson(json));
  }

  Stream<FirebaseResult<List<Orders>>> getOrdersWanting() {
    return getItemsOnStream(
        _orderRepository.getAllOrderWanting(), (json) => Orders.fromJson(json));
  }

  Future<FirebaseResult<List<Orders>>> getOrders(
      {required String tableName}) async {
    return getItems(await _orderRepository.getOrders(nameTable: tableName),
        (json) => Orders.fromJson(json));
  }

  // Stream<List<Order>> getAllOrderOnWanting() {
  //   try {
  //     return _orderRepository.getAllOrderWanting().map((event) {
  //       var orders = <Order>[];
  //       orders.addAll(event.docs.map((e) => Orders.fromJson(e.data())).toList());
  //       return orders;
  //     });
  //   } catch (e) {
  //     throw '$e';
  //   }
  // }

  // Future<void> updateFoodInOrder(
  //     {required String idOrder,
  //     required List<Map<String, dynamic>> jsonData,
  //     required num totalPrice}) async {
  //   try {
  //     await _orderRepository.updateOrderItem(
  //         idOrder: idOrder, json: jsonData, totalPrice: totalPrice);
  //   } catch (e) {
  //     throw '$e';
  //   }
  // }

  // Future<void> deleteOrder({required String idOrder}) async {
  //   try {
  //     await _orderRepository.deleteOrder(idOrder: idOrder);
  //   } catch (e) {
  //     throw '$e';
  //   }
  // }

  // Future<void> paymentOrder({required String idOrder}) async {
  //   try {
  //     await _orderRepository.paymentOrder(idOrder: idOrder);
  //   } catch (e) {
  //     throw '$e';
  //   }
  // }

  // Future<List<Order>> getHistoryOrder() async {
  //   try {
  //     var orders = <Order>[];
  //     var res = await _orderRepository.getHistoryOrder();
  //     orders.addAll(res.docs.map((e) => Order.fromJson(e.data())).toList());
  //     return orders;
  //   } catch (e) {
  //     throw '$e';
  //   }
  // }
}
