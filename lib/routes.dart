import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:picple/data/model/response/nearby_photos_response.dart';
import 'package:picple/presentation/component/picple_bottom_navigation_bar.dart';
import 'package:picple/presentation/home/view/home_page.dart';
import 'package:picple/presentation/login/view/login_page.dart';
import 'package:picple/presentation/map/provider/map_provider.dart';
import 'package:picple/presentation/map/view/map_page.dart';
import 'package:picple/presentation/profile/view/profile_page.dart';
import 'package:picple/presentation/profile_edit/view/profile_edit_page.dart';
import 'package:picple/presentation/recommendation/view/recommendation_page.dart';
import 'package:picple/presentation/setting/view/setting_page.dart';
import 'package:picple/presentation/shared/photo_detail/view/photo_detail_page.dart';
import 'package:picple/presentation/shared/photo_list/view/location_photo_list_page.dart';
import 'package:picple/presentation/shared/photo_list/view/photo_list_page.dart';
import 'package:picple/presentation/splash/view/splash_page.dart';
import 'package:picple/presentation/theme/picple_colors.dart';
import 'package:picple/presentation/upload/provider/upload_contract.dart';
import 'package:picple/presentation/upload/view/in_app_camera_page.dart';
import 'package:picple/presentation/upload/view/upload_page.dart';

enum Routes {
  splash(name: 'Splash', path: '/'),
  login(name: 'Login', path: '/login'),
  home(name: 'Home', path: '/home'),
  map(name: 'Map', path: '/map'),
  upload(name: 'Upload', path: '/upload'),
  camera(name: 'Camera', path: '/camera'),
  recommendation(name: 'Recommendation', path: '/recommendation'),

  photoDetail(name: 'PhotoDetail', path: '/photo_detail'),
  photoList(name: 'PhotoList', path: '/photo_list'),
  photoListByLocation(name: 'PhotoListByLocation', path: '/photo_list_location'),

  profile(name: 'Profile', path: '/profile'),
  profileEdit(name: 'ProfileEdit', path: 'profile_edit'),
  setting(name: 'Setting', path: 'setting');

  final String name;
  final String path;

  const Routes({required this.name, required this.path});
}

final router = GoRouter(
  initialLocation: Routes.splash.path,
  routes: [
    GoRoute(
      path: Routes.splash.path,
      builder: (context, state) => const SplashPage(),
    ),

    GoRoute(
      path: Routes.login.path,
      builder: (context, state) => const LoginPage(),
    ),

    GoRoute(
      path: "${Routes.photoDetail.path}/:id",
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id']!);
        if (id == null) {
          return const Scaffold(body: Center(child: Text('Invalid photo ID')));
        }
        return PhotoDetailPage(photoId: id);
      }
    ),

    GoRoute(
      path: "${Routes.photoList.path}/:id",
      builder: (context, state)  {
        final id = int.tryParse(state.pathParameters['id']!);
        if (id == null) {
          return const Scaffold(body: Center(child: Text('Invalid photo ID')));
        }
        return PhotoListPage(centerPhotoId: id);
      }
    ),

    GoRoute(
      path: Routes.photoListByLocation.path,
      builder: (context, state) {
        final location = state.uri.queryParameters['location'];
        if (location == null || location.isEmpty) {
          return const Scaffold(body: Center(child: Text('Invalid location')));
        }
        return LocationPhotoListPage(location: location);
      },
    ),

    GoRoute(
      path: Routes.upload.path,
      builder: (context, state) => const UploadPage(),
    ),

    GoRoute(
      path: Routes.camera.path,
      builder: (context, state) => const InAppCameraPage(),
    ),

    GoRoute(
      path: Routes.recommendation.path,
      builder: (context, state) {
        final extra = state.extra;
        final tagIds = extra is List<int> ? extra : const <int>[];
        return RecommendationPage(tagIds: tagIds);
      },
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: Routes.home.path,
                builder: (context, state) => const HomePage(),
                routes: []
            ),
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: Routes.map.path,
                builder: (context, state) => const MapPage(),
                routes: []
            ),
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: Routes.profile.path,
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: Routes.profileEdit.path,
                    builder: (context, state) => const ProfileEditPage(),
                  ),
                  GoRoute(
                    path: Routes.setting.path,
                    builder: (context, state) => const SettingPage(),
                  ),
                ]
            ),
          ]
        )
      ]
    )
  ],
);

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  bool _isTopLevelRoute(BuildContext context) {
    final location = GoRouter.of(context).routeInformationProvider.value.uri.path;

    final topLevelRoutes = [
      Routes.home.path,
      Routes.map.path,
      Routes.profile.path,
    ];

    return topLevelRoutes.contains(location);
  }

  @override
  Widget build(BuildContext context) {
    final showBottomBar = _isTopLevelRoute(context);

    return Scaffold(
      body: navigationShell,
      backgroundColor: PicpleColors.white,
      bottomNavigationBar: showBottomBar
        ? PicpleBottomNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) {
              navigationShell.goBranch(index);
            },
            onUploadTap: () async {
              final container = ProviderScope.containerOf(context);
              final result = await context.push(Routes.upload.path);

              if (result is UploadCompletedResult) {
                container
                    .read(mapStateProvider.notifier)
                    .addPhoto(result.photo);
                await context.push(
                  Routes.recommendation.path,
                  extra: result.tagIds,
                );
              } else if (result is PhotoData) {
                container.read(mapStateProvider.notifier).addPhoto(result);
              }
            },
          )
        : null,
    );
  }
}
