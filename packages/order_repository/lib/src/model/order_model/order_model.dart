import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_repository/src/model/food_model/food_model.dart';

class OrderModel {
  String? id;
  bool? isPay;
  String? table;
  String? dateOrder;
  String? datePay;
  String? date;
  num? totalPrice;
  List<Food>? foods;
  OrderModel(
      {this.id,
      this.isPay,
      this.table,
      this.dateOrder,
      this.datePay,
      this.date,
      this.totalPrice,
      this.foods});

  factory OrderModel.fromFirestore(DocumentSnapshot snapshot) {
    var foods = <Food>[];

    var data = <String, dynamic>{};
    if (snapshot.data() != null) {
      data = snapshot.data() as Map<String, dynamic>;
      if (data['order_food'] != null) {
        data['order_food'].map((e) {
          foods.add(Food.fromJson(e, e['id']));
        }).toList();
      }
    }

    return OrderModel(
        id: snapshot.id,
        isPay: data['isPay'] ?? false,
        dateOrder: data['dateOrder'] ?? "",
        datePay: data['datePay'] ?? "",
        date: data['date'] ?? "",
        table: data['table'] ?? "",
        totalPrice: data['totalPrice'] ?? 0,
        foods: foods);
  }

  factory OrderModel.fromJson(Map<dynamic, dynamic> data, String? id) {
    // Map data = snapshot.data() as Map<dynamic, dynamic>;
    var foods = <Food>[];
    if (data['order_food'] != null) {
      data['order_food'].map((e) {
        foods.add(Food.fromJson(e, e['id']));
      }).toList();
    }
    return OrderModel(
        id: id,
        isPay: data['isPay'] ?? false,
        dateOrder: data['dateOrder'] ?? "",
        datePay: data['datePay'] ?? "",
        date: data['date'] ?? "",
        table: data['table'] ?? "",
        totalPrice: data['totalPrice'] ?? 0,
        foods: foods);
  }
}
