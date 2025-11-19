import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picple/data/api/auth_api.dart';
import 'package:picple/data/api/profile_api.dart';
import 'package:picple/data/api/storage_api.dart';
import 'package:picple/data/api/tag_api.dart';
import 'package:picple/data/datasource/profile_data_source.dart';
import 'package:picple/data/dio_client.dart';
import 'package:picple/data/repository/auth_repository.dart';
import 'package:picple/data/repository/photo_repository.dart';
import 'package:picple/data/repository/profile_repository.dart';
import 'package:picple/data/repository/tag_repository.dart';

import 'api/photo_api.dart';
import 'datasource/auth_data_source.dart';
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

final profileApiProvider = Provider<ProfileApi>((ref) =>
    ProfileApi(ref.watch(dioClientProvider))
);
final profileDataSourceProvider = Provider<ProfileDataSource>((ref) => 
    ProfileDataSourceImpl(ref.watch(profileApiProvider))
);
// final profileDataSourceProvider = Provider<ProfileDataSource>((ref) => 
//     ProfileDataSource(ref.watch(profileApiProvider))
// );
final profileRepositoryProvider = Provider<ProfileRepository>((ref) =>
    ProfileRepository(ref.watch(profileDataSourceProvider))
);

final photoApiProvider = Provider<PhotoApi>((ref) =>
    PhotoApi(ref.watch(dioClientProvider))
);
final photoDataSourceProvider = Provider<PhotoDataSource>((ref) {
    return PhotoDataSourceImpl(
        ref.watch(photoApiProvider)
    );
});
final photoRepositoryProvider = Provider<PhotoRepository>((ref) {
    return PhotoRepository(
        ref.watch(photoDataSourceProvider)
    );
});

final tagApiProvider = Provider<TagApi>((ref) =>
    TagApi(ref.watch(dioClientProvider))
);

final tagRepositoryProvider = Provider<TagRepository>((ref) =>
    TagRepositoryImpl(ref.watch(tagApiProvider))
);
