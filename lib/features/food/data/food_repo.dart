import 'package:admin_menu_mobile/common/firebase/firebase_result.dart';
import 'package:food_repository/food_repository.dart';
import '../../../common/firebase/firebase_base.dart';
import '../model/food_model.dart';

class FoodRepo extends FirebaseBase<Food> {
  final FoodRepository _foodRepository;

  FoodRepo({required FoodRepository foodRepository})
      : _foodRepository = foodRepository;

  Future<FirebaseResult<List<Food>>> getFoods() async {
    try {
      return await getItems(await _foodRepository.getFoods(), Food.fromJson);
    } catch (e) {
      throw '$e';
    }
  }

  Stream<Food> getFoodByID({required String idFood}) {
    try {
      return _foodRepository
          .getFoodByID(idFood: idFood)
          .map((event) => Food.fromJson(event.data()!));
    } catch (e) {
      throw '$e';
    }
  }

  Future<FirebaseResult<bool>> createFood({required Food food}) async {
    try {
      return await createItem(_foodRepository.createFood(food.toJson()));
    } catch (e) {
      throw '$e';
    }
  }

  Future<FirebaseResult<bool>> deleteFood({required String foodID}) async {
    return await deleteItem(_foodRepository.deleteFood(idFood: foodID));
  }

  Future<FirebaseResult<bool>> updateFood({required Food food}) async {
    return await updateItem(
        _foodRepository.updateFood(foodID: food.id ?? '', data: food.toJson()));
  }
}
