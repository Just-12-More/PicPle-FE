import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picple/data/dio_client.dart';
import 'package:picple/data/repository/auth_repository.dart';
import 'package:picple/data/services/auth_service.dart';
import 'package:picple/data/services/storage_service.dart';

import 'datasource/auth_data_source.dart';
import 'datasource/fake_auth_data_source.dart';

final dioClientProvider = Provider<DioClient>((ref) => DioClient());
final storageServiceProvider = Provider<StorageService>((ref) => StorageService());
final authServiceProvider = Provider<AuthService>((ref) =>
    AuthService(
        ref.watch(dioClientProvider),
        ref.watch(storageServiceProvider)
    )
);
final authDataSourceProvider = Provider<AuthDataSource>((_) => FakeAuthDataSource());
final authRepositoryProvider = Provider<AuthRepository>((ref) {
    return AuthRepository(
        ref.watch(authDataSourceProvider),
        ref.watch(storageServiceProvider),
    );
});