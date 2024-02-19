import 'package:admin_menu_mobile/features/food/data/food_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String? id;
  bool? isPay;
  String? table;
  String? dateOrder;
  String? datePay;
  String? date;
  num? totalPrice;
  List<FoodModel>? foods;
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
    var foods = <FoodModel>[];

    var data = <String, dynamic>{};
    if (snapshot.data() != null) {
      data = snapshot.data() as Map<String, dynamic>;
      if (data['order_food'] != null) {
        data['order_food'].map((e) {
          foods.add(FoodModel.fromJson(e, e['id']));
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
    var foods = <FoodModel>[];
    if (data['order_food'] != null) {
      data['order_food'].map((e) {
        foods.add(FoodModel.fromJson(e, e['id']));
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
