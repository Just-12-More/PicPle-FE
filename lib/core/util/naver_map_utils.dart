import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:picple/core/util/image_utils.dart';

final Map<String, NOverlayImage> _markerIconCache = {};
final Map<String, Future<_OverlayImageResult>> _pendingIconLoads = {};

const int _maxConcurrentImageLoads = 6;
int _activeImageLoads = 0;
final Queue<_ImageLoadRequest> _imageLoadQueue = Queue<_ImageLoadRequest>();

String _cacheKey(String imageUrl, double width, double height) =>
    '$imageUrl-${width.toInt()}x${height.toInt()}';

Future<_OverlayImageResult> _loadOverlayImageFromUrl(
  String imageUrl,
  double width,
  double height,
) {
  return _enqueueImageLoad(
    () => _performOverlayImageLoad(imageUrl, width, height),
  );
}

Future<_OverlayImageResult> _performOverlayImageLoad(
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
    final icon = await NOverlayImage.fromByteArray(bytes);
    return _OverlayImageResult(icon, cacheable: true);
  } catch (e) {
    log('Error loading image from URL: $e');
    return const _OverlayImageResult(
      NOverlayImage.fromAssetImage('assets/images/img_placeholder.png'),
      cacheable: false,
    );
  }
}

Future<NOverlayImage> _getOrCreateOverlayImage(
    String imageUrl, double width, double height) async {
  final key = _cacheKey(imageUrl, width, height);

  if (_markerIconCache.containsKey(key)) {
    return _markerIconCache[key]!;
  }

  final loader = _pendingIconLoads.putIfAbsent(
    key,
    () => _loadOverlayImageFromUrl(imageUrl, width, height),
  );
  try {
    final result = await loader;
    if (result.cacheable) {
      _markerIconCache[key] = result.image;
    }
    return result.image;
  } finally {
    if (_pendingIconLoads[key] == loader) {
      _pendingIconLoads.remove(key);
    }
  }
}

class _OverlayImageResult {
  final NOverlayImage image;
  final bool cacheable;

  const _OverlayImageResult(this.image, {required this.cacheable});
}

class _ImageLoadRequest {
  final Future<_OverlayImageResult> Function() task;
  final Completer<_OverlayImageResult> completer;

  _ImageLoadRequest(this.task, this.completer);
}

Future<_OverlayImageResult> _enqueueImageLoad(
  Future<_OverlayImageResult> Function() task,
) {
  final completer = Completer<_OverlayImageResult>();
  _imageLoadQueue.add(_ImageLoadRequest(task, completer));
  _tryStartNextImageLoad();
  return completer.future;
}

void _tryStartNextImageLoad() {
  if (_activeImageLoads >= _maxConcurrentImageLoads) {
    return;
  }
  if (_imageLoadQueue.isEmpty) {
    return;
  }

  final request = _imageLoadQueue.removeFirst();
  _activeImageLoads++;
  request
      .task()
      .then(request.completer.complete)
      .catchError(request.completer.completeError)
      .whenComplete(() {
    _activeImageLoads--;
    _tryStartNextImageLoad();
  });
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
