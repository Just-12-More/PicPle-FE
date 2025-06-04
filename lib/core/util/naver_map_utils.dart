import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:picple/core/util/image_utils.dart';

Future<NOverlayImage> createOverlayImageFromUrl(String imageUrl) async {
  try {
    final bytes = await loadAndResizeImageFromUrl(imageUrl: imageUrl);
    return await NOverlayImage.fromByteArray(bytes);
  } catch (e) {
    log('Error loading image from URL: $e');
    return const NOverlayImage.fromAssetImage('assets/images/img_placeholder.png');
  }
}

Future<void> addMarkerWithPlaceholderImage({
  required NaverMapController controller,
  required String id,
  required NLatLng position,
  required String imageUrl,
  int zIndex = 0,
  void Function()? onTap,
}) async {
  const placeholder = NOverlayImage.fromAssetImage('assets/images/img_placeholder.png');

  final marker = NMarker(
    id: id,
    position: position,
    icon: placeholder,
    size: const Size(48, 48),
  );

  marker.setOnTapListener((NMarker marker) {
    onTap?.call();
  });

  controller.addOverlay(marker);

  try {
    final realImage = await createOverlayImageFromUrl(imageUrl);

    marker.setIcon(realImage);
  } catch (e) {
    log('Error loading image from URL: $e');
  }
}