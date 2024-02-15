part of 'table_bloc.dart';

sealed class TableState extends Equatable {
  const TableState();

  @override
  List<Object> get props => [];
}

final class TableInitial extends TableState {}

final class TableInProgress extends TableState {}

final class TableSuccess extends TableState {
  final List<TableModel>? tables;
  const TableSuccess({this.tables});

  @override
  List<Object> get props => [tables!];
}

final class TableFailure extends TableState {
  final String? error;
  const TableFailure({this.error});

  @override
  List<Object> get props => [error!];
}
