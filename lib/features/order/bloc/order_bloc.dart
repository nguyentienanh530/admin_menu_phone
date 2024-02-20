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
  OrderBloc() : super(const OrderState()) {
    on<GetOrderOnTable>(_getOrderOnTable);
    on<GetAllOrder>(_getAllOrder);
    on<GetOrderByID>(_getOrderByID);
    on<UpdateFoodInOrder>(_updateFoodInOrder);
    on<DeleteOrder>(_deleteOrder);
    on<PaymentOrder>(_paymentOrder);
    on<GetOrderHistory>(_getOrderHistory);
  }

  FutureOr<void> _getOrderOnTable(
      GetOrderOnTable event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      await emit.forEach(
          OrderRepo(
                  orderRepository: OrderRepository(
                      firebaseFirestore: FirebaseFirestore.instance))
              .getOrderOnTable(nameTable: event.nameTable),
          onData: (data) =>
              state.copyWith(status: OrderStatus.success, orders: data),
          onError: (error, stackTrace) => state.copyWith(
              status: OrderStatus.failure, message: error.toString()));
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, message: e.toString()));
    }
  }

  FutureOr<void> _getAllOrder(
      GetAllOrder event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      await emit.forEach<List<OrderModel>>(
          OrderRepo(
                  orderRepository: OrderRepository(
                      firebaseFirestore: FirebaseFirestore.instance))
              .getAllOrderOnWanting(),
          onData: (data) =>
              state.copyWith(status: OrderStatus.success, orders: data),
          onError: (error, stackTrace) => state.copyWith(
              status: OrderStatus.failure, message: error.toString()));
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, message: e.toString()));
    }
  }

  FutureOr<void> _getOrderByID(
      GetOrderByID event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      await emit.forEach<OrderModel>(
          OrderRepo(
                  orderRepository: OrderRepository(
                      firebaseFirestore: FirebaseFirestore.instance))
              .getOrderByID(idOrder: event.idOrder!),
          onData: (data) =>
              state.copyWith(status: OrderStatus.success, order: data),
          onError: (error, stackTrace) => state.copyWith(
              status: OrderStatus.failure, message: error.toString()));
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, message: e.toString()));
    }
  }

  FutureOr<void> _updateFoodInOrder(
      UpdateFoodInOrder event, Emitter<OrderState> emit) async {
    try {
      await OrderRepo(
              orderRepository: OrderRepository(
                  firebaseFirestore: FirebaseFirestore.instance))
          .updateFoodInOrder(
              idOrder: event.idOrder,
              jsonData: event.json,
              totalPrice: event.totalPrice);
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, message: e.toString()));
    }
  }

  FutureOr<void> _deleteOrder(
      DeleteOrder event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      await OrderRepo(
              orderRepository: OrderRepository(
                  firebaseFirestore: FirebaseFirestore.instance))
          .deleteOrder(idOrder: event.idOrder);
      emit(state.copyWith(status: OrderStatus.success, message: 'Đã xóa'));
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, message: e.toString()));
    }
  }

  FutureOr<void> _paymentOrder(
      PaymentOrder event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      await OrderRepo(
              orderRepository: OrderRepository(
                  firebaseFirestore: FirebaseFirestore.instance))
          .paymentOrder(idOrder: event.idOrder);
      emit(state.copyWith(
          status: OrderStatus.success, message: 'Đã thanh toán'));
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, message: e.toString()));
    }
  }

  FutureOr<void> _getOrderHistory(
      GetOrderHistory event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      var orders = await OrderRepo(
              orderRepository: OrderRepository(
                  firebaseFirestore: FirebaseFirestore.instance))
          .getHistoryOrder();
      emit(state.copyWith(status: OrderStatus.success, orders: orders));
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, message: e.toString()));
    }
  }
}
