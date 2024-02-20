part of 'order_bloc.dart';

enum OrderStatus { initial, loading, success, failure }

class OrderState extends Equatable {
  const OrderState(
      {this.status = OrderStatus.initial,
      this.orders = const <OrderModel>[],
      this.order = const OrderModel(),
      this.message = ''});
  final OrderStatus status;
  final List<OrderModel> orders;
  final OrderModel order;
  final String message;

  OrderState copyWith(
      {OrderStatus? status,
      List<OrderModel>? orders,
      OrderModel? order,
      String? message}) {
    return OrderState(
        status: status ?? this.status,
        orders: orders ?? this.orders,
        order: order ?? this.order,
        message: message ?? this.message);
  }

  @override
  List<Object> get props => [status, orders, order, message];
}
