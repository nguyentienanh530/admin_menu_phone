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
