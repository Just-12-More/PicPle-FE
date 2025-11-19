import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NativeMediaPicker {
  static const _channel = MethodChannel('picple/picker');

  static Future<File?> takePicture() async {
    return _invokeForFile('takePicture');
  }

  static Future<File?> pickFromGallery() async {
    return _invokeForFile('pickFromGallery');
  }

  static Future<File?> _invokeForFile(String method) async {
    try {
      final path = await _channel.invokeMethod<String>(method);
      if (path == null || path.isEmpty) {
        return null;
      }
      return File(path);
    } on PlatformException catch (e) {
      debugPrint('Native media picker error: $e');
      return null;
    }
  }
}
