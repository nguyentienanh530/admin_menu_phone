import 'dart:async';
import 'package:admin_menu_mobile/common/bloc/bloc_helper.dart';
import 'package:admin_menu_mobile/common/bloc/generic_bloc_state.dart';
import 'package:admin_menu_mobile/features/table/data/table_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_repository/table_repository.dart';
import '../model/table_model.dart';
part 'table_event.dart';

typedef Emit = Emitter<GenericBlocState<TableModel>>;

class TableBloc extends Bloc<TableEvent, GenericBlocState<TableModel>>
    with BlocHelper<TableModel> {
  TableBloc() : super(GenericBlocState.loading()) {
    on<TablesFetched>(_getAllTable);
    on<TableDeleted>(_deleteTable);
    on<TableCreated>(_createTable);
  }
  final _tableRepository = TableRepo(
      tableRepository:
          TableRepository(firebaseFirestore: FirebaseFirestore.instance));

  FutureOr<void> _getAllTable(TablesFetched event, Emit emit) async {
    await getItems(_tableRepository.getTable(), emit);
  }

  FutureOr<void> _deleteTable(TableDeleted event, Emit emit) async {
    await deleteItem(
        _tableRepository.deleteTable(idTable: event.idTable), emit);
  }

  FutureOr<void> _createTable(TableCreated event, Emit emit) async {
    await createItem(
        _tableRepository.createTable(table: event.tableModel), emit);
  }
}
