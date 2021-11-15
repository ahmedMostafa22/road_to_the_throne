import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageHelper {
  static Future<String> uploadFile(File file, String path) async {
    try {
      TaskSnapshot task = await FirebaseStorage.instance
          .ref('$path/${getFileNameFromFile(file)}')
          .putFile(file);
      return task.ref.getDownloadURL();
    } on FirebaseException {
      throw FirebaseException;
    } on SocketException {
      throw SocketException;
    } on Exception {
      throw Exception;
    }
  }

  static String getFileNameFromFile(File file) =>
      file.path.substring(file.path.lastIndexOf('/') + 1);
}
