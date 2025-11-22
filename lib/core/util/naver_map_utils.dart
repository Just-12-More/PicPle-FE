import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:picple/core/util/image_utils.dart';

final Map<String, NOverlayImage> _markerIconCache = {};

Future<NOverlayImage>  createOverlayImageFromUrl(
  String imageUrl,
  double width,
  double height,
) async {
  try {
    final bytes = await loadAndResizeImageFromUrl(
      imageUrl: imageUrl,
      targetWidth: width.toInt(),
      targetHeight: height.toInt(),
    );
    return await NOverlayImage.fromByteArray(bytes);
  } catch (e) {
    log('Error loading image from URL: $e');
    return const NOverlayImage.fromAssetImage('assets/images/img_placeholder.png');
  }
}

Future<void> addMarkerWithImage({
  required NaverMapController controller,
  required String id,
  required NLatLng position,
  required String imageUrl,
  double width = 60,
  double height = 60,
  int zIndex = 0,
  int? globalZIndex,
  void Function()? onTap,
}) async {
  try {
    final cachedIcon = _markerIconCache[id];
    final icon = cachedIcon ?? await createOverlayImageFromUrl(imageUrl, width, height);
    _markerIconCache[id] = icon;

    final marker = NClusterableMarker(
      id: id,
      position: position,
      icon: icon,
      size: Size(width, height),
    );

    marker.setZIndex(zIndex);
    if (globalZIndex != null) {
      marker.setGlobalZIndex(globalZIndex);
    }

    marker.setOnTapListener((NMarker marker) {
      onTap?.call();
    });

    controller.addOverlay(marker);
  } catch (e) {
    log('Error adding marker: $e');
  }
}
