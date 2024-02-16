import 'package:cloud_firestore/cloud_firestore.dart';

class FoodRepository {
  final FirebaseFirestore _firebaseFirestore;

  FoodRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  Future<QuerySnapshot<Map<String, dynamic>>> getFoods() async {
    try {
      var res = await _firebaseFirestore.collection('food').get();
      return res;
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }
}
