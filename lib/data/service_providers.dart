import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picple/data/api/auth_api.dart';
import 'package:picple/data/api/storage_api.dart';
import 'package:picple/data/dio_client.dart';
import 'package:picple/data/repository/auth_repository.dart';
import 'package:picple/data/repository/photo_repository.dart';

import 'api/photo_api.dart';
import 'datasource/auth_data_source.dart';
import 'datasource/fake_photo_data_source.dart';
import 'datasource/photo_data_source.dart';

final dioClientProvider = Provider<DioClient>((ref) => DioClient());
final storageApiProvider = Provider<StorageApi>((ref) => StorageApi());

final authApiProvider = Provider<AuthApi>((ref) =>
    AuthApi(
        ref.watch(dioClientProvider),
        ref.watch(storageApiProvider)
    )
);
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  return AuthDataSourceImpl(
    ref.watch(authApiProvider)
  );
});
final authRepositoryProvider = Provider<AuthRepository>((ref) {
    return AuthRepository(
        ref.watch(authDataSourceProvider),
        ref.watch(storageApiProvider),
    );
});

final photoApiProvider = Provider<PhotoApi>((ref) =>
    PhotoApi(ref.watch(dioClientProvider))
);
final photoDataSourceProvider = Provider<PhotoDataSource>((ref) => FakePhotoDataSource());
final photoRepositoryProvider = Provider<PhotoRepository>((ref) {
    return PhotoRepository(
        ref.watch(photoDataSourceProvider)
    );
});
