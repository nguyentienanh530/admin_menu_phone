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

final class DeleteFoodInOrder extends OrderEvent {
  final String idOrder;
  final List<Map<String, dynamic>> json;
  final num totalPrice;

  const DeleteFoodInOrder(
      {required this.idOrder, required this.json, required this.totalPrice});
}

final class DeleteOrder extends OrderEvent {
  final String idOrder;

  const DeleteOrder({required this.idOrder});
}
