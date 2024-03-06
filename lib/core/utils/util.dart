import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'utils.dart';

class Ultils {
  static String currencyFormat(double double) {
    final oCcy = NumberFormat("###,###,###", "vi");
    return oCcy.format(double);
  }

  static String formatDateTime(String dateTimeString) {
    final inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    final outputFormat = DateFormat('HH:mm - dd/MM/yyyy');

    final dateTime = inputFormat.parse(dateTimeString);
    return outputFormat.format(dateTime);
  }

  static String formatToDate(String dateTimeString) {
    final inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    final outputFormat = DateFormat('yyyy-MM-dd');
    final dateTime = inputFormat.parse(dateTimeString);
    return outputFormat.format(dateTime);
  }

  static String reverseDate(String dateTimeString) {
    final inputFormat = DateFormat('yyyy-MM-dd');
    final outputFormat = DateFormat('dd/MM/yyyy');
    final dateTime = inputFormat.parse(dateTimeString);
    return outputFormat.format(dateTime);
  }

  static String tableStatus(String tableStatus) {
    switch (tableStatus) {
      case 'available':
        return 'Trống';
      case 'occupied':
        return 'Sử dụng';
      default:
        return 'Trống';
    }
  }

  static num foodPrice(
      {required bool isDiscount,
      required num foodPrice,
      required int discount}) {
    double discountAmount = (foodPrice * discount.toDouble()) / 100;
    num discountedPrice = foodPrice - discountAmount;

    return isDiscount ? discountedPrice : foodPrice;
  }
}

Future pop(BuildContext context, int returnedLevel) async {
  for (var i = 0; i < returnedLevel; ++i) {
    context.pop<bool>(true);
  }
}

Future<String> uploadImage({required String path, required File file}) async {
  var image = '';
  Reference storageReference =
      FirebaseStorage.instance.ref().child('$path${file.path.split('/').last}');
  UploadTask uploadTask = storageReference.putFile(file);
  await uploadTask.whenComplete(() async {
    var url = await storageReference.getDownloadURL();
    image = url.toString();
  });
  return image;
}

Future<dynamic> pickImage() async {
  // ignore: prefer_typing_uninitialized_variables
  var imageFile;
  final imagePicker = ImagePicker();
  var imagepicked = await imagePicker.pickImage(
      source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
  if (imagepicked != null) {
    imageFile = File(imagepicked.path);
  } else {
    logger.d('No image selected!');
  }
  return imageFile;
}
