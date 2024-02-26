import 'package:admin_menu_mobile/common/firebase/firebase_base.dart';
import 'package:admin_menu_mobile/common/firebase/firebase_result.dart';
import 'package:table_repository/table_repository.dart';

import '../model/table_model.dart';

class TableRepo extends FirebaseBase<TableModel> {
  final TableRepository _tableRepository;

  TableRepo({required TableRepository tableRepository})
      : _tableRepository = tableRepository;

  Future<FirebaseResult<List<TableModel>>> getTable() async {
    Future<FirebaseResult<List<TableModel>>> result =
        getItems(await _tableRepository.getAllTable(), TableModel.fromJson);
    return result;
  }

  Future<FirebaseResult> deleteTable({required String idTable}) async {
    return await deleteItem(_tableRepository.deleteTable(idTable: idTable));
  }

  Future<FirebaseResult<bool>> createTable({required TableModel table}) async {
    return await createItem(
        _tableRepository.createTable(dataJson: table.toJson()));
  }

  Future<FirebaseResult<bool>> updateTable({required TableModel table}) async {
    return await updateItem(_tableRepository.updateTable(
        idTbale: table.id!, dataJson: table.toJson()));
  }
}
