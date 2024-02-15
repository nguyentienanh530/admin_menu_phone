import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TableModel extends Equatable {
  final String? id;
  final String? name;
  final String? image;
  final num? seats;

  const TableModel({this.id, this.name, this.image, this.seats});

  factory TableModel.fromFirestore(DocumentSnapshot snapshot) {
    Map data = snapshot.data() as Map<dynamic, dynamic>;
    return TableModel(
        id: snapshot.id,
        name: data['name'] ?? '',
        image: data['image'] ?? '',
        seats: data['seats'] ?? 0);
  }

  TableModel copyWith({String? id, String? name, String? image, num? seats}) {
    return TableModel(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        seats: seats ?? this.seats);
  }

  @override
  List<Object?> get props => [id, name, image, seats];
}
