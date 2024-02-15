import 'package:order_repository/order_repository.dart';

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
}
