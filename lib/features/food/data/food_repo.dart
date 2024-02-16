import 'package:food_repository/food_repository.dart';

class FoodRepo {
  final FoodRepository _foodRepository;

  FoodRepo({required FoodRepository foodRepository})
      : _foodRepository = foodRepository;

  Future<List<FoodModel>> getFoods() async {
    try {
      var foods = <FoodModel>[];
      var res = await _foodRepository.getFoods();
      foods.addAll(res.docs.map((e) => FoodModel.fromFirestore(e)).toList());
      return foods;
    } catch (e) {
      throw '$e';
    }
  }
}
