import 'dart:async';
import 'package:admin_menu_mobile/features/order/data/order_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<GetOrderOnTable>(_getOrderOnTable);
    on<GetAllOrder>(_getAllOrder);
  }

  FutureOr<void> _getOrderOnTable(
      GetOrderOnTable event, Emitter<OrderState> emit) async {
    emit(OrderInProgress());

    try {
      var orders = await OrderRepo(
              orderRepository: OrderRepository(
                  firebaseFirestore: FirebaseFirestore.instance))
          .getOrderOnTable(nameTable: event.nameTable)
          .first;
      emit(OrderSuccess(orderModel: orders));
    } catch (e) {
      emit(OrderFailure(error: e.toString()));
    }
  }

  FutureOr<void> _getAllOrder(
      GetAllOrder event, Emitter<OrderState> emit) async {
    emit(OrderInProgress());
    try {
      var orders = await OrderRepo(
              orderRepository: OrderRepository(
                  firebaseFirestore: FirebaseFirestore.instance))
          .getAllOrder()
          .first;
      emit(OrderSuccess(orderModel: orders));
    } catch (e) {
      emit(OrderFailure(error: e.toString()));
    }
  }
}
