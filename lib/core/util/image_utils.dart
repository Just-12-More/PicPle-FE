import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

Future<Uint8List> loadAndResizeImageFromUrl({
  required String imageUrl,
  int targetWidth = 60,
  int targetHeight = 60,
  int quality = 80,
}) async {
  final response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode != 200) {
    throw Exception('이미지 다운로드 실패: $imageUrl');
  }

  final params = _ResizeParams(
    bytes: Uint8List.fromList(response.bodyBytes),
    targetWidth: targetWidth,
    targetHeight: targetHeight,
    quality: quality,
  );

  return _imageResizePool.process(params);
}

Future<File> resizeAndCompressImageFile({
  required File file,
  int targetWidth = 1024,
  int quality = 80,
}) async {
  final bytes = await file.readAsBytes();
  final params = _ResizeParams(
    bytes: bytes,
    targetWidth: targetWidth,
    targetHeight: null,
    quality: quality,
  );

  final compressed = await _imageResizePool.process(params);
  final tempDir = Directory.systemTemp;
  final compressedFile = await File('${tempDir.path}/resized_${path.basename(file.path)}')
      .writeAsBytes(compressed);

  return compressedFile;
}

class _ResizeParams {
  final Uint8List bytes;
  final int targetWidth;
  final int? targetHeight;
  final int quality;

  const _ResizeParams({
    required this.bytes,
    required this.targetWidth,
    required this.targetHeight,
    required this.quality,
  });
}

Uint8List _resizeBytes(_ResizeParams params) {
  final originalImage = img.decodeImage(params.bytes);
  if (originalImage == null) {
    throw Exception('이미지 디코딩 실패');
  }

  final resized = img.copyResize(
    originalImage,
    width: params.targetWidth,
    height: params.targetHeight,
    interpolation: img.Interpolation.linear,
  );

  final jpgBytes = img.encodeJpg(resized, quality: params.quality);
  return Uint8List.fromList(jpgBytes);
}

class _ImageResizePool {
  _ImageResizePool() {
    _initialization = _initializeWorkers();
  }

  static const int _maxFallbackWorkers = 1;

  late final Future<void> _initialization;
  final List<_ResizeWorker> _workers = [];
  int _nextWorkerIndex = 0;

  Future<void> _initializeWorkers() async {
    final workerCount = Platform.numberOfProcessors > 0
        ? Platform.numberOfProcessors
        : _maxFallbackWorkers;
    for (var i = 0; i < workerCount; i++) {
      final worker = await _ResizeWorker.spawn();
      _workers.add(worker);
    }
  }

  Future<Uint8List> process(_ResizeParams params) async {
    await _initialization;
    if (_workers.isEmpty) {
      throw StateError('No resize workers available');
    }
    final worker = _workers[_nextWorkerIndex];
    _nextWorkerIndex = (_nextWorkerIndex + 1) % _workers.length;
    return worker.process(params);
  }
}

final _imageResizePool = _ImageResizePool();

class _ResizeWorker {
  _ResizeWorker._(this._responsePort);

  final ReceivePort _responsePort;
  late final SendPort _commandPort;
  final Map<int, Completer<Uint8List>> _pendingJobs = {};
  int _jobCounter = 0;

  static Future<_ResizeWorker> spawn() async {
    final responsePort = ReceivePort();
    final initPort = ReceivePort();
    await Isolate.spawn<List<dynamic>>(
      _resizeWorkerEntryPoint,
      <dynamic>[initPort.sendPort, responsePort.sendPort],
    );
    final commandPort = await initPort.first as SendPort;
    initPort.close();
    final worker = _ResizeWorker._(responsePort)
      .._commandPort = commandPort;
    responsePort.listen(worker._handleResponse);
    return worker;
  }

  Future<Uint8List> process(_ResizeParams params) {
    final jobId = _jobCounter++;
    final completer = Completer<Uint8List>();
    _pendingJobs[jobId] = completer;
    _commandPort.send({
      'id': jobId,
      'bytes': params.bytes,
      'targetWidth': params.targetWidth,
      'targetHeight': params.targetHeight,
      'quality': params.quality,
    });
    return completer.future;
  }

  void _handleResponse(dynamic message) {
    if (message is Map) {
      final id = message['id'] as int;
      final completer = _pendingJobs.remove(id);
      if (completer == null) {
        return;
      }

      final error = message['error'];
      if (error != null) {
        completer.completeError(Exception(error));
        return;
      }

      final bytes = message['bytes'];
      if (bytes is Uint8List) {
        completer.complete(bytes);
      } else {
        completer.completeError(Exception('잘못된 응답 형식'));
      }
    }
  }
}

void _resizeWorkerEntryPoint(List<dynamic> initialMessage) {
  final initSendPort = initialMessage[0] as SendPort;
  final resultSendPort = initialMessage[1] as SendPort;
  final commandPort = ReceivePort();
  initSendPort.send(commandPort.sendPort);

  commandPort.listen((message) {
    if (message is Map) {
      final jobId = message['id'] as int;
      try {
        final params = _ResizeParams(
          bytes: message['bytes'] as Uint8List,
          targetWidth: message['targetWidth'] as int,
          targetHeight: message['targetHeight'] as int?,
          quality: message['quality'] as int,
        );
        final resized = _resizeBytes(params);
        resultSendPort.send({'id': jobId, 'bytes': resized});
      } catch (e) {
        resultSendPort.send({'id': jobId, 'error': e.toString()});
      }
    }
  });
}
