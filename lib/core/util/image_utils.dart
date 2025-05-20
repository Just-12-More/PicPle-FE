import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

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