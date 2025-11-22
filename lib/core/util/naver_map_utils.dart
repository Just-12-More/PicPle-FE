import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:picple/core/util/image_utils.dart';

final Map<String, NOverlayImage> _markerIconCache = {};
final Map<String, Future<NOverlayImage>> _pendingIconLoads = {};

String _cacheKey(String imageUrl, double width, double height) =>
    '$imageUrl-${width.toInt()}x${height.toInt()}';

Future<NOverlayImage> _loadOverlayImageFromUrl(
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

Future<NOverlayImage> _getOrCreateOverlayImage(
    String imageUrl, double width, double height) async {
  final key = _cacheKey(imageUrl, width, height);

  if (_markerIconCache.containsKey(key)) {
    return _markerIconCache[key]!;
  }

  if (_pendingIconLoads.containsKey(key)) {
    return _pendingIconLoads[key]!;
  }

  final loader = _loadOverlayImageFromUrl(imageUrl, width, height);
  _pendingIconLoads[key] = loader;
  try {
    final icon = await loader;
    _markerIconCache[key] = icon;
    return icon;
  } finally {
    _pendingIconLoads.remove(key);
  }
}

Future<NClusterableMarker> createMarkerWithImage({
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
    final icon = await _getOrCreateOverlayImage(imageUrl, width, height);

    final marker = NClusterableMarker(
      id: id,
      position: position,
      icon: icon,
      size: Size(width, height),
    )
      ..setZIndex(zIndex);

    if (globalZIndex != null) {
      marker.setGlobalZIndex(globalZIndex);
    }

    if (onTap != null) {
      marker.setOnTapListener((_) => onTap());
    }

    return marker;
  } catch (e) {
    log('Error creating marker: $e');
    rethrow;
  }
}

Future<void> addMarkersInBatches({
  required NaverMapController controller,
  required List<NMarker> markers,
  int batchSize = 50,
}) async {
  if (markers.isEmpty) return;

  for (var i = 0; i < markers.length; i += batchSize) {
    final batch = markers.skip(i).take(batchSize).toSet();
    final overlaySet = batch.map<NAddableOverlay>((marker) => marker).toSet();
    await controller.addOverlayAll(overlaySet);
  }
}
