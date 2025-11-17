import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:picple/core/socket/socket_manager.dart';
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
