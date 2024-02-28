import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
part 'food_model.freezed.dart';
part 'food_model.g.dart';

DateTime _sendAtFromJson(Timestamp timestamp) =>
    DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);

// Timestamp _sendAtFromJson(Timestamp timestamp) => timestamp;

@freezed
class Food with _$Food {
  factory Food({
    @Default(0) num? ratting,
    // ignore: invalid_annotation_target
    // @JsonKey(name: 'date', fromJson: _sendAtFromJson) final DateTime? date,
    @Default('') String? image,
    @Default(false) bool? isImageCrop,
    @Default(false) bool? isDiscount,
    @Default('') String? description,
    @Default('') String? id,
    @Default('') String? category,
    @Default(0) int? discount,
    @Default('') String? location,
    @Default(0) double? long,
    @Default(0) double? lat,
    @Default('') String? payment,
    @Default(0) num? price,
    @Default('') String? driver,
    @Default('') String? title,
    @Default(0) int? count,
    @Default(<dynamic>[]) List? photoGallery,
    @Default(0) int? valueAffordable,
    @Default(0) int? valueTaste,
    @Default(0) int? valuePackaging,
    @Default(0) int? valueYummy,
    @Default('') String? dateOrder,
    @Default('') String? name,
    @Default('') String? photoProfile,
    @Default('') String? status,
    @Default('') String? locationUser,
    @Default('') String? fcm,
    @Default(0) int? timeOrder,
    @Default(0) int quantity,
    @Default(0) num totalPrice,
    @Default('') String? note,
  }) = _Food;

  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);
}
