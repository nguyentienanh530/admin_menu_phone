part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

final class OrdersOnTableFecthed extends OrderEvent {
  final String? nameTable;

  const OrdersOnTableFecthed({required this.nameTable});
}

final class OrdersWantingFecthed extends OrderEvent {}

final class OrdersFecthed extends OrderEvent {
  final String tableName;

  const OrdersFecthed({required this.tableName});
}
