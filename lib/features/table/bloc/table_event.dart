part of 'table_bloc.dart';

sealed class TableEvent extends Equatable {
  const TableEvent();

  @override
  List<Object> get props => [];
}

final class TablesFetched extends TableEvent {}

final class TableDeleted extends TableEvent {
  final String idTable;

  const TableDeleted({required this.idTable});
}

final class TableCreated extends TableEvent {
  final TableModel tableModel;

  const TableCreated({required this.tableModel});
}

final class TableUpdated extends TableEvent {}
