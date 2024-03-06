import 'package:admin_menu_mobile/common/firebase/firebase_base.dart';
import 'package:admin_menu_mobile/common/firebase/firebase_result.dart';
import 'package:order_repository/order_repository.dart';
import '../../model/order_model.dart';

class OrderRepo extends FirebaseBase<Orders> {
  final OrderRepository _orderRepository;

  OrderRepo({required OrderRepository orderRepository})
      : _orderRepository = orderRepository;

  Stream<FirebaseResult<List<Orders>>> getOrderOnTable({String? tableID}) {
    return getItemsOnStream(_orderRepository.getOrderOnTable(tableID: tableID),
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

  Future<FirebaseResult<List<Orders>>> getOrdersOnTable(
      {required String tableID}) async {
    return getItems(await _orderRepository.getOrders(tableID: tableID),
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

  Future<FirebaseResult<bool>> deleteOrder({required String orderID}) async {
    return await deleteItem(_orderRepository.deleteOrder(orderID: orderID));
  }

  Future<FirebaseResult<List<Orders>>> getAllOrder() async {
    return await getItems(
        await _orderRepository.getAllOrder(), Orders.fromJson);
  }
}
