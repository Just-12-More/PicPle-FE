import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermission({
  required BuildContext context,
  required Permission permission,
  required String errorMessage,
}) async {
  final status = await permission.status;

  if (status.isGranted) return true;

  final result = await permission.request();

  if (result.isGranted) return true;

  if (result.isPermanentlyDenied) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('$errorMessage\n설정에서 권한을 허용해주세요.'),
            behavior: SnackBarBehavior.floating,
            action: const SnackBarAction(
              label: '설정 열기',
              onPressed: openAppSettings,
            ),
          ),
        );
    }
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  return false;
}