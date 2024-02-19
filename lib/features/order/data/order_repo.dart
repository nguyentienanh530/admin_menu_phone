import 'package:order_repository/order_repository.dart';

import '../dtos/order_model.dart';

class OrderRepo {
  final OrderRepository _orderRepository;

  OrderRepo({required OrderRepository orderRepository})
      : _orderRepository = orderRepository;

  Stream<List<OrderModel>> getOrderOnTable({String? nameTable}) {
    try {
      return _orderRepository
          .getOrderOnTable(nameTable: nameTable)
          .map((event) {
        var orders = <OrderModel>[];
        orders.addAll(
            event.docs.map((e) => OrderModel.fromFirestore(e)).toList());
        return orders;
      });
    } catch (e) {
      throw '$e';
    }
  }

  Stream<OrderModel> getOrderByID({required String idOrder}) {
    try {
      return _orderRepository.getOrderByID(id: idOrder).map((e) {
        return OrderModel.fromFirestore(e);
      });
    } catch (e) {
      throw '$e';
    }
  }

  Stream<List<OrderModel>> getAllOrder() {
    try {
      return _orderRepository.getAllOrder().map((event) {
        var orders = <OrderModel>[];
        orders.addAll(
            event.docs.map((e) => OrderModel.fromFirestore(e)).toList());
        return orders;
      });
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> deleteFoodInOrder(
      {required String idOrder,
      required List<Map<String, dynamic>> jsonData,
      required num totalPrice}) async {
    try {
      await _orderRepository.deleteOrderItem(
          idOrder: idOrder, json: jsonData, totalPrice: totalPrice);
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> deleteOrder({required String idOrder}) async {
    try {
      await _orderRepository.deleteOrder(idOrder: idOrder);
    } catch (e) {
      throw '$e';
    }
  }
}
