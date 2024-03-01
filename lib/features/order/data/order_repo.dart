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

  Future<FirebaseResult<Orders>> getOrderByID({required String orderID}) async {
    return getItem(await _orderRepository.getOrderByID(orderID: orderID),
        (json) => Orders.fromJson(json));
  }

  Future<FirebaseResult<List<Orders>>> getOrders(
      {required String tableName}) async {
    return getItems(await _orderRepository.getOrders(nameTable: tableName),
        (json) => Orders.fromJson(json));
  }

  Future<FirebaseResult<List<Orders>>> getHistoryOrder() async {
    return getItems(await _orderRepository.getHistoryOrder(),
        (json) => Orders.fromJson(json));
  }

  Future<FirebaseResult<bool>> updateOrder({required Orders orders}) async {
    return await updateItem(
        _orderRepository.updateOrder(jsonData: orders.toJson()));
  }

  // Future<void> paymentOrder({required String idOrder}) async {
  //   try {
  //     await _orderRepository.paymentOrder(idOrder: idOrder);
  //   } catch (e) {
  //     throw '$e';
  //   }
  // }
}
