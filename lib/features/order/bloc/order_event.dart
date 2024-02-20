part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

final class GetOrderOnTable extends OrderEvent {
  final String? nameTable;

  const GetOrderOnTable({required this.nameTable});
}

final class GetAllOrder extends OrderEvent {}

final class GetOrderByID extends OrderEvent {
  final String? idOrder;

  const GetOrderByID({required this.idOrder});
}

final class UpdateFoodInOrder extends OrderEvent {
  final String idOrder;
  final List<Map<String, dynamic>> json;
  final num totalPrice;

  const UpdateFoodInOrder(
      {required this.idOrder, required this.json, required this.totalPrice});
}

final class DeleteOrder extends OrderEvent {
  final String idOrder;

  const DeleteOrder({required this.idOrder});
}

final class PaymentOrder extends OrderEvent {
  final String idOrder;

  const PaymentOrder({required this.idOrder});
}

final class GetOrderHistory extends OrderEvent {}
