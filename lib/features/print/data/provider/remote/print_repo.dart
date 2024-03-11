import 'package:print_repository/print_repository.dart';
import '../../../../../common/firebase/firebase_base.dart';
import '../../../../../common/firebase/firebase_result.dart';
import '../../model/print_model.dart';

class PrintRepo extends FirebaseBase<PrintModel> {
  final PrintRepository _printRepository;

  PrintRepo({required PrintRepository printRepository})
      : _printRepository = printRepository;

  Future<FirebaseResult<List<PrintModel>>> getPrints() async {
    return await getItems(
        await _printRepository.getPrints(), PrintModel.fromJson);
  }
}
