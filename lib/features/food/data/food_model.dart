import 'package:admin_menu_mobile/utils/contants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodModel {
  final num? ratting;
  final Timestamp? date;
  final String? image;
  final bool? isImageCrop;
  final bool? isDiscount;
  final String? description;
  final String? id;
  final String? category;
  final int? discount;
  final String? location;
  final double? long;
  final double? lat;
  final String? payment;
  final num? price;
  final String? driver;
  final String? title;
  final int? count;
  final List? photoGallery;
  final int? valueAffordable;
  final int? valueTaste;
  final int? valuePackaging;
  final int? valueYummy;
  final String? dateOrder;
  final String? name;
  final String? photoProfile;
  final String? status;
  final String? locationUser;
  final String? fcm;
  final int? timeOrder;
  int? quantity;

  num? totalPrice;
  final String? note;

  FoodModel(
      {this.category,
      this.date,
      this.description,
      this.id,
      this.location,
      this.price,
      this.fcm,
      this.title,
      this.payment,
      this.count,
      this.photoGallery,
      this.valueAffordable,
      this.valueTaste,
      this.valuePackaging,
      this.driver,
      this.valueYummy,
      this.image,
      this.isImageCrop,
      this.isDiscount,
      this.discount,
      this.ratting,
      this.long,
      this.lat,
      this.dateOrder,
      this.name,
      this.photoProfile,
      this.status,
      this.timeOrder,
      this.quantity,
      this.totalPrice,
      this.locationUser,
      this.note});

  factory FoodModel.fromFirestore(DocumentSnapshot snapshot) {
    Map data = snapshot.data() as Map<dynamic, dynamic>;

    logger.d(data['photoGallery']);
    return FoodModel(
        ratting: data['ratting'] ?? 1,
        category: data['category'] ?? "",
        date: data['date'],
        payment: data['payment'] ?? "",
        quantity: data['quantity'] ?? 1,
        totalPrice: data['totalPrice'] ?? data['price'] ?? 0,
        description: data['description'] ?? "",
        id: snapshot.id,
        image: data["image"] ?? '',
        driver: data['driver'] ?? "",
        fcm: data['fcm'] ?? "",
        dateOrder: data['dateOrder'] ?? "",
        name: data['name'] ?? "",
        photoProfile: data['photoProfile'] ?? "",
        status: data['status'] ?? "",
        timeOrder: data['timeOrder'] ?? 0,
        count: data['count'] ?? 1,
        location: data['location'] ?? "",
        price: data['price'] ?? 1,
        title: data['title'] ?? "",
        locationUser: data['locationUser'] ?? "",
        photoGallery: data['photoGallery'] == null || data['photoGallery'] == []
            ? []
            : data['photoGallery'],
        valueAffordable: data['valueAffordable'] ?? 0,
        valueTaste: data['valueTaste'] ?? 0,
        valuePackaging: data['valuePackaging'] ?? 0,
        valueYummy: data['valueYummy'] ?? 0,
        isImageCrop: data['isImageCrop'] ?? false,
        isDiscount: data['isDiscount'] ?? false,
        discount: data['discount'] ?? 0,
        note: data['note']);
  }
  factory FoodModel.fromJson(Map<dynamic, dynamic> data, String? id) {
    // Map data = snapshot.data() as Map<dynamic, dynamic>;

    return FoodModel(
        ratting: data['ratting'] ?? 1,
        category: data['category'] ?? "",
        date: data['date'],
        quantity: data['quantity'] ?? 1,
        totalPrice: data['totalPrice'] ?? data['price'] ?? 0,
        description: data['description'] ?? "",
        id: id.toString(),
        image: data["image"] ?? '',
        driver: data['driver'] ?? "",
        dateOrder: data['dateOrder'] ?? "",
        name: data['name'] ?? "",
        photoProfile: data['photoProfile'] ?? "",
        status: data['status'] ?? "",
        timeOrder: data['timeOrder'] ?? 0,
        count: data['count'] ?? 1,
        location: data['location'] ?? "",
        price: data['price'] ?? 1.0,
        title: data['title'] ?? "",
        locationUser: data['locationUser'] ?? "",
        photoGallery: data['photoGallery'] ?? [],
        valueAffordable: data['valueAffordable'] ?? 0,
        valueTaste: data['valueTaste'] ?? 0,
        valuePackaging: data['valuePackaging'] ?? 0,
        valueYummy: data['valueYummy'] ?? 0,
        isImageCrop: data['isImageCrop'] ?? false,
        isDiscount: data['isDiscount'] ?? false,
        discount: data['discount'] ?? 0,
        note: data['note']);
  }

  Map<String, dynamic> toJson(FoodModel food) => {
        "category": food.category,
        "date": food.date,
        "description": food.description,
        "id": food.id,
        "image": food.image,
        "isImageCrop": food,
        "isDiscount": food.isDiscount,
        "discount": food.discount,
        'createdAt': FieldValue.serverTimestamp(),
        'count': 0,
        "price": food.price,
        "title": food.title,
        'photoGallery': food.photoGallery,
        "ratting": 4.5
      };

  String toStringg(FoodModel food) {
    return {
      "category": food.category,
      "date": food.date,
      "description": food.description,
      "id": food.id,
      "image": food.image,
      "isImageCrop": food,
      "isDiscount": food.isDiscount,
      "discount": food.discount,
      'createdAt': FieldValue.serverTimestamp(),
      'count': 0,
      "price": food.price,
      "title": food.title,
      'photoGallery': food.photoGallery,
      "ratting": 4.5
    }.toString();
  }
}
