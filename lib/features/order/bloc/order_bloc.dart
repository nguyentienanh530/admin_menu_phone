import 'dart:async';
import 'package:admin_menu_mobile/features/order/data/order_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository.dart';

import '../dtos/order_model.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<GetOrderOnTable>(_getOrderOnTable);
    on<GetAllOrder>(_getAllOrder);
    on<GetOrderByID>(_getOrderByID);
    on<DeleteFoodInOrder>(_deleteInOrder);
    on<DeleteOrder>(_deleteOrder);
  }

  FutureOr<void> _getOrderOnTable(
      GetOrderOnTable event, Emitter<OrderState> emit) async {
    emit(OrderInProgress());

    try {
      await emit.forEach(
          OrderRepo(
                  orderRepository: OrderRepository(
                      firebaseFirestore: FirebaseFirestore.instance))
              .getOrderOnTable(nameTable: event.nameTable),
          onData: (data) => OrderSuccess(orderModel: data),
          onError: (error, stackTrace) =>
              OrderFailure(error: error.toString()));
    } catch (e) {
      emit(OrderFailure(error: e.toString()));
    }
  }

  FutureOr<void> _getAllOrder(
      GetAllOrder event, Emitter<OrderState> emit) async {
    emit(OrderInProgress());

    try {
      await emit.forEach<List<OrderModel>>(
          OrderRepo(
                  orderRepository: OrderRepository(
                      firebaseFirestore: FirebaseFirestore.instance))
              .getAllOrder(),
          onData: (data) {
            return OrderSuccess(orderModel: data);
          },
          onError: (error, stackTrace) =>
              OrderFailure(error: error.toString()));
    } catch (e) {
      emit(OrderFailure(error: e.toString()));
    }
  }

  FutureOr<void> _getOrderByID(
      GetOrderByID event, Emitter<OrderState> emit) async {
    emit(OrderInProgress());
    try {
      await emit.forEach<OrderModel>(
          OrderRepo(
                  orderRepository: OrderRepository(
                      firebaseFirestore: FirebaseFirestore.instance))
              .getOrderByID(idOrder: event.idOrder!),
          onData: (data) => OrderSuccess(orderModel: data),
          onError: (error, stackTrace) =>
              OrderFailure(error: error.toString()));
    } catch (e) {
      emit(OrderFailure(error: e.toString()));
    }
  }

  FutureOr<void> _deleteInOrder(
      DeleteFoodInOrder event, Emitter<OrderState> emit) async {
    emit(OrderInProgress());
    try {
      await OrderRepo(
              orderRepository: OrderRepository(
                  firebaseFirestore: FirebaseFirestore.instance))
          .deleteFoodInOrder(
              idOrder: event.idOrder,
              jsonData: event.json,
              totalPrice: event.totalPrice);
      emit(const OrderSuccess(orderModel: 'Success'));
    } catch (e) {
      emit(OrderFailure(error: e.toString()));
    }
  }

  FutureOr<void> _deleteOrder(
      DeleteOrder event, Emitter<OrderState> emit) async {
    emit(OrderInProgress());
    try {
      await OrderRepo(
              orderRepository: OrderRepository(
                  firebaseFirestore: FirebaseFirestore.instance))
          .deleteOrder(idOrder: event.idOrder);
      emit(const OrderSuccess(orderModel: 'Success'));
    } catch (e) {
      emit(OrderFailure(error: e.toString()));
    }
  }
}
