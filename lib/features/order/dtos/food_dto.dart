import 'package:admin_menu_mobile/features/food/model/food_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodDto {
  final String? image;
  final bool? isDiscount;
  final String? id;
  final int? discount;
  final bool? isImageCrop;
  final num? price;
  final String? title;
  final int? timeOrder;
  final int? quantity;
  final num? totalPrice;
  final String? note;

  FoodDto(
      {this.isImageCrop,
      this.id,
      this.price,
      this.title,
      this.image,
      this.isDiscount,
      this.discount,
      this.timeOrder,
      this.quantity,
      this.totalPrice,
      this.note});

  factory FoodDto.fromFirestore(DocumentSnapshot snapshot) {
    Map data = snapshot.data() as Map<dynamic, dynamic>;

    return FoodDto(
        isImageCrop: data['isImageCrop'] ?? false,
        quantity: data['quantity'] ?? 1,
        totalPrice: data['totalPrice'] ?? data['price'] ?? 0,
        id: snapshot.id,
        image: data["image"] ?? '',
        timeOrder: data['timeOrder'] ?? 0,
        price: data['price'] ?? 1,
        title: data['title'] ?? "",
        isDiscount: data['isDiscount'] ?? false,
        discount: data['discount'] ?? 0,
        note: data['note']);
  }
  factory FoodDto.fromJson(Map<dynamic, dynamic> data, String? id) {
    // Map data = snapshot.data() as Map<dynamic, dynamic>;

    return FoodDto(
        isImageCrop: data['isImageCrop'] ?? false,
        quantity: data['quantity'] ?? 1,
        totalPrice: data['totalPrice'] ?? data['price'] ?? 0,
        id: id.toString(),
        image: data["image"] ?? '',
        timeOrder: data['timeOrder'] ?? 0,
        price: data['price'] ?? 1.0,
        title: data['title'] ?? "",
        isDiscount: data['isDiscount'] ?? false,
        discount: data['discount'] ?? 0,
        note: data['note']);
  }

  Map<String, dynamic> toJson(Food food) => {
        'id': food.id.toString(),
        'timeOrder': food.timeOrder,
        'quantity': food.quantity,
        'totalPrice': food.totalPrice ?? food.price,
        'discount': food.discount,
        "image": food.image,
        'isDiscount': food.isDiscount,
        'isImageCrop': food.isImageCrop,
        'price': food.price,
        'title': food.title,
        'note': food.note ?? ''
      };
}
