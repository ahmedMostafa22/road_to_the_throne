import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static Future<File> pickImage(
      ImageSource source, BuildContext context) async {
    try {
      PickedFile? pickedFile = await ImagePicker().getImage(source: source);
      return File(pickedFile!.path);
    } catch (e) {
      return File('');
    }
  }
}
