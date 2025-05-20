import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picple/data/dio_client.dart';
import 'package:picple/data/services/auth_service.dart';
import 'package:picple/data/services/storage_service.dart';

final dioClientProvider = Provider<DioClient>((ref) => DioClient());
final storageServiceProvider = Provider<StorageService>((ref) => StorageService());
final authServiceProvider = Provider<AuthService>((ref) =>
    AuthService(
        ref.watch(dioClientProvider),
        ref.watch(storageServiceProvider)
    )
);