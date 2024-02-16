import 'package:table_repository/table_repository.dart';

import 'table_model.dart';

class TableRepo {
  final TableRepository _tableRepository;

  TableRepo({required TableRepository tableRepository})
      : _tableRepository = tableRepository;

  Future<List<TableModel>> getTable() async {
    var tables = <TableModel>[];
    try {
      var res = await _tableRepository.getAllTable();
      res.docs.map((e) => tables.add(TableModel.fromFirestore(e))).toList();
      return tables;
    } catch (e) {
      throw '$e';
    }
  }
}
