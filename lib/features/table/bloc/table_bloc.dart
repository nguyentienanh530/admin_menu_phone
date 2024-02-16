import 'dart:async';
import 'package:admin_menu_mobile/features/table/data/table_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_repository/table_repository.dart';

import '../data/table_model.dart';

part 'table_event.dart';
part 'table_state.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  TableBloc() : super(TableInitial()) {
    // on<TableEvent>((event, emit) {

    // });
    on<GetAllTable>(_getAllTable);
  }

  FutureOr<void> _getAllTable(
      GetAllTable event, Emitter<TableState> emit) async {
    emit(TableInProgress());
    try {
      var tables = await TableRepo(
              tableRepository: TableRepository(
                  firebaseFirestore: FirebaseFirestore.instance))
          .getTable();
      emit(TableSuccess(tables: tables));
    } catch (e) {
      emit(TableFailure(error: e.toString()));
    }
  }
}
