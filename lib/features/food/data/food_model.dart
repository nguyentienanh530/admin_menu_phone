import 'package:cloud_firestore/cloud_firestore.dart';

class FoodModel {
  num? ratting;
  Timestamp? date;
  String? image;
  bool? isImageCrop;
  bool? isDiscount;
  String? description;
  String? id;
  String? category;
  int? discount;
  String? location;
  double? long;
  double? lat;
  String? payment;
  num? price;
  String? driver;
  String? title;
  int? count;
  List? photoGallery;
  int? valueAffordable;
  int? valueTaste;
  int? valuePackaging;
  int? valueYummy;
  String? dateOrder;
  String? name;
  String? photoProfile;
  String? status;
  String? locationUser;
  String? fcm;
  int? timeOrder;
  int? quantity;
  num? totalPrice;
  String? note;

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
