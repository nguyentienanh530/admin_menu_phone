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

  Future<QuerySnapshot<Map<String, dynamic>>> getHistoryOrder() {
    try {
      return _firebaseFirestore
          .collection("AllOrder")
          .where("isPay", isEqualTo: true)
          .get();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllOrder() {
    try {
      return _firebaseFirestore.collection("AllOrder").snapshots();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllOrderWanting() {
    try {
      return _firebaseFirestore
          .collection("AllOrder")
          .where('isPay', isEqualTo: false)
          .snapshots();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderByID(
      {required String id}) {
    try {
      var data = _firebaseFirestore.collection("AllOrder").doc(id).snapshots();
      return data;
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> updateOrderItem(
      {required String idOrder,
      required List<Map<String, dynamic>> json,
      required num totalPrice}) async {
    try {
      await _firebaseFirestore
          .collection('AllOrder')
          .doc(idOrder)
          .update({'order_food': json, 'totalPrice': totalPrice});
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> deleteOrder({required String idOrder}) async {
    try {
      await _firebaseFirestore.collection('AllOrder').doc(idOrder).delete();
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> paymentOrder({required String idOrder}) async {
    try {
      await _firebaseFirestore
          .collection('AllOrder')
          .doc(idOrder)
          .update({'isPay': true, "datePay": DateTime.now().toString()});
    } on FirebaseException catch (e) {
      throw '$e';
    } catch (e) {
      throw '$e';
    }
  }
}
