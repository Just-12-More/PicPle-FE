import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

Future<Uint8List> loadAndResizeImageFromUrl({
  required String imageUrl,
  int targetWidth = 48,
  int targetHeight = 48,
  int quality = 75,
}) async {
  final response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode != 200) {
    throw Exception('이미지 다운로드 실패: $imageUrl');
  }

  final originalImage = img.decodeImage(response.bodyBytes);
  if (originalImage == null) {
    throw Exception('이미지 디코딩 실패');
  }

  final resized = img.copyResize(
    originalImage,
    width: targetWidth,
    height: targetHeight,
    interpolation: img.Interpolation.linear,
  );

  final jpgBytes = img.encodeJpg(resized, quality: quality);
  return Uint8List.fromList(jpgBytes);
}

Future<File> resizeAndCompressImageFile({
  required File file,
  int targetWidth = 1024,
  int quality = 80,
}) async {
  final bytes = await file.readAsBytes();
  final original = img.decodeImage(bytes);

  if (original == null) {
    throw Exception('이미지 디코딩 실패');
  }

  final resized = img.copyResize(
    original,
    width: targetWidth,
    interpolation: img.Interpolation.linear,
  );

  final compressed = img.encodeJpg(resized, quality: quality);

  final tempDir = Directory.systemTemp;
  final compressedFile = await File('${tempDir.path}/resized_${path.basename(file.path)}')
      .writeAsBytes(Uint8List.fromList(compressed));

  return compressedFile;
}