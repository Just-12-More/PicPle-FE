import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:picple/routes.dart';

import 'config.dart';

Future<void> main() async {
  await Config.init();
  WidgetsFlutterBinding.ensureInitialized();

  KakaoSdk.init(nativeAppKey: Config.kakaoNativeAppKey);

  await FlutterNaverMap().init(
    clientId: Config.naverClientId,
    onAuthFailed: (e) {
      log("NaverMapSdk auth failed: $e");
    }
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
