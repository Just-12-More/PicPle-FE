import 'package:get_it/get_it.dart';
import 'package:picple/data/dio_client.dart';
import 'package:picple/services/auth_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => DioClient());
  locator.registerLazySingleton(() => AuthService(locator<DioClient>()));
}
