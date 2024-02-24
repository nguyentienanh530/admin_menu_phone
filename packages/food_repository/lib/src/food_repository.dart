import 'package:cloud_firestore/cloud_firestore.dart';

class FoodRepository {
  final FirebaseFirestore _firebaseFirestore;

  FoodRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  Future<QuerySnapshot<Map<String, dynamic>>> getFoods() async {
    try {
      return await _firebaseFirestore.collection('food').get();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getFoodByID(
      {required String idFood}) {
    try {
      return _firebaseFirestore.collection('food').doc(idFood).snapshots();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<DocumentReference<Map<String, dynamic>>> createFood(
      Map<String, dynamic> data) async {
    try {
      return await _firebaseFirestore.collection('food').add(data);
    } catch (e) {
      throw '$e';
    }
  }

  Future deleteFood({required String idFood}) async {
    try {
      await _firebaseFirestore.collection('food').doc(idFood).delete();
    } catch (e) {
      return false;
    }
  }

  Future<void> updateFood(
      {required String idFood, required Map<String, dynamic> data}) async {
    try {
      await _firebaseFirestore.collection('food').doc(idFood).update(data);
    } catch (e) {
      throw '$e';
    }
  }
}
