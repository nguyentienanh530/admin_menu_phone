import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_repository/food_repository.dart';

import 'food_model.dart';

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

  Future<DocumentReference<Map<String, dynamic>>> createFood(
      Map<String, dynamic> data) async {
    try {
      return await _foodRepository.createFood(data);
    } catch (e) {
      throw '$e';
    }
  }

  Future deleteFood({required String idFood}) async {
    try {
      await _foodRepository.deleteFood(idFood: idFood);
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> updateFood(
      {required String idFood, required Map<String, dynamic> data}) async {
    try {
      await _foodRepository.updateFood(idFood: idFood, data: data);
    } catch (e) {
      throw '$e';
    }
  }
}
