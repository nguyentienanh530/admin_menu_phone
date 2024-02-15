part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}

final class OrderInProgress extends OrderState {}

final class OrderSuccess extends OrderState {
  final List<OrderModel>? orderModel;

  const OrderSuccess({required this.orderModel});
  @override
  List<Object> get props => [orderModel!];
}

final class OrderFailure extends OrderState {
  final String? error;

  const OrderFailure({required this.error});
  @override
  List<Object> get props => [error!];
}
