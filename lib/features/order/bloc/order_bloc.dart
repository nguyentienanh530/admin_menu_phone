import 'dart:async';
import 'package:admin_menu_mobile/common/bloc/bloc_helper.dart';
import 'package:admin_menu_mobile/common/bloc/generic_bloc_state.dart';
import 'package:admin_menu_mobile/features/order/data/order_repo.dart';
import 'package:admin_menu_mobile/features/order/dtos/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository.dart';

part 'order_event.dart';

typedef Emit = Emitter<GenericBlocState<Orders>>;

class OrderBloc extends Bloc<OrderEvent, GenericBlocState<Orders>>
    with BlocHelper<Orders> {
  OrderBloc() : super(GenericBlocState.loading()) {
    on<OrdersOnTableFecthed>(_getOrderOnTable);
    on<OrdersWantingFecthed>(_getOdersWanting);
    on<OrdersFecthed>(_getOrders);
  }
  final _orderRepository = OrderRepo(
      orderRepository:
          OrderRepository(firebaseFirestore: FirebaseFirestore.instance));

  FutureOr<void> _getOrderOnTable(OrdersOnTableFecthed event, Emit emit) async {
    return getItemsOnStream(
        _orderRepository.getOrderOnTable(nameTable: event.nameTable), emit);
  }

  FutureOr<void> _getOdersWanting(OrdersWantingFecthed event, Emit emit) {
    return getItemsOnStream(_orderRepository.getOrdersWanting(), emit);
  }

  FutureOr<void> _getOrders(
      OrdersFecthed event, Emitter<GenericBlocState<Orders>> emit) async {
    return await getItems(
        _orderRepository.getOrders(tableName: event.tableName), emit);
  }
}
