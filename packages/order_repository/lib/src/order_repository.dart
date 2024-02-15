import 'package:cloud_firestore/cloud_firestore.dart';

class OrderRepository {
  final FirebaseFirestore _firebaseFirestore;

  OrderRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  Stream<QuerySnapshot<Map<String, dynamic>>> getOrderOnTable(
      {String? nameTable}) {
    try {
      return _firebaseFirestore
          .collection("AllOrder")
          .where("table", isEqualTo: nameTable)
          .where("isPay", isEqualTo: false)
          .snapshots();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllOrder({String? nameTable}) {
    try {
      return _firebaseFirestore.collection("AllOrder").snapshots();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }
}
