import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:picple/core/socket/socket_manager.dart';
import 'package:picple/data/model/response/hot_places_response.dart';
import 'package:picple/presentation/hot_place/provider/hot_place_provider.dart';
import 'package:picple/routes.dart';

import 'config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config.init();

  KakaoSdk.init(nativeAppKey: Config.kakaoNativeAppKey);

  await FlutterNaverMap().init(
    clientId: Config.naverClientId,
    onAuthFailed: (e) {
      log("NaverMapSdk auth failed: $e");
    },
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  ProviderSubscription<AsyncValue<dynamic>>? _socketSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() {
      ref.read(socketManagerProvider.notifier);
      _socketSubscription = ref.listenManual<AsyncValue<SocketMessage>>(
        socketMessagesProvider,
        (previous, next) {
          next.whenData((message) {
            log(
              'Socket message from ${message.destination}: ${message.body}',
            );
            _handleSocketMessage(message);
          });
        },
      );
    });
  }

  @override
  void dispose() {
    _socketSubscription?.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final manager = ref.read(socketManagerProvider.notifier);
    switch (state) {
      case AppLifecycleState.resumed:
        unawaited(manager.reconnect());
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        unawaited(manager.pause());
        break;
      case AppLifecycleState.detached:
        unawaited(manager.pause());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PicPle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}

extension on _MyAppState {
  void _handleSocketMessage(SocketMessage message) {
    final destination = Config.socketDestination;
    if (destination != null && message.destination != destination) {
      return;
    }

    final body = message.body;
    if (body == null) return;

    try {
      final decoded = jsonDecode(body) as Map<String, dynamic>;
      final hotPlaces = HotPlacesData.fromJson(decoded).hotPlaces;
      ref.read(hotPlaceProvider.notifier).setHotPlaces(hotPlaces);
    } catch (e, stack) {
      log('Failed to handle hot places message: $e', stackTrace: stack);
    }
  }
}
