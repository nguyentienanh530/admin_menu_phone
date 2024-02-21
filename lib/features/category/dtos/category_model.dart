import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String? id;
  String? name;

  String? image;

  CategoryModel({
    this.id,
    this.name,
    this.image,
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot snapshot) {
    Map data = snapshot.data() as Map<dynamic, dynamic>;

    return CategoryModel(
      id: snapshot.id,
      name: data['name'] ?? '',
      image: data['image'] ?? '',
    );
  }
}
