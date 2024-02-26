import 'package:admin_menu_mobile/common/firebase/firebase_base.dart';
import 'package:admin_menu_mobile/common/firebase/firebase_result.dart';
import 'package:admin_menu_mobile/features/user/model/user_model.dart';
import 'package:user_repository/user_repository.dart';

class UserRepo extends FirebaseBase<UserModel> {
  final UserRepository _userRepository;

  UserRepo({required UserRepository userRepository})
      : _userRepository = userRepository;
  Future<FirebaseResult<bool>> createUser(
      {required UserModel userModel}) async {
    return await createItem(
        _userRepository.createUser(userJson: userModel.toJson()));
  }

  Future<FirebaseResult<bool>> updateToken(
      {required String userID, required String token}) async {
    return await updateItem(
        _userRepository.updateAdminToken(userID: userID, token: token));
  }

  Future<FirebaseResult<List<UserModel>>> getUser(
      {required String userID}) async {
    return await getItem(
        await _userRepository.getUser(userID: userID), UserModel.fromJson);
  }
}
