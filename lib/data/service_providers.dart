import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picple/data/api/auth_api.dart';
import 'package:picple/data/api/storage_api.dart';
import 'package:picple/data/dio_client.dart';
import 'package:picple/data/repository/auth_repository.dart';
import 'package:picple/data/repository/photo_repository.dart';

import 'datasource/auth_data_source.dart';
import 'datasource/fake_auth_data_source.dart';
import 'datasource/fake_photo_data_source.dart';
import 'datasource/photo_data_source.dart';

final dioClientProvider = Provider<DioClient>((ref) => DioClient());
final storageServiceProvider = Provider<StorageApi>((ref) => StorageApi());

final authServiceProvider = Provider<AuthApi>((ref) =>
    AuthApi(
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

final photoDataSourceProvider = Provider<PhotoDataSource>((ref) => FakePhotoDataSource());
final photoRepositoryProvider = Provider<PhotoRepository>((ref) {
    return PhotoRepository(
        ref.watch(photoDataSourceProvider)
    );
});
