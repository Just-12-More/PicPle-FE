import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class FlutterImagePicker {
  FlutterImagePicker._();

  static final ImagePicker _picker = ImagePicker();

  static Future<File?> takePicture() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.camera);
    if (file == null) return null;
    return File(file.path);
  }

  static Future<File?> pickFromGallery() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return null;
    return File(file.path);
  }

  static Future<File?> retrieveLostImage() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return null;
    }

    final List<XFile>? files = response.files;
    if (files != null && files.isNotEmpty) {
      return File(files.first.path);
    }

    final XFile? file = response.file;
    if (file != null) {
      return File(file.path);
    }

    final exception = response.exception;
    if (exception != null) {
      debugPrint(
        'ImagePicker lost data error: ${exception.code} ${exception.message}',
      );
    }
    return null;
  }
}
