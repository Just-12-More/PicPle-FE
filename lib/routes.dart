import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picple/presentation/component/picple_bottom_navigation_bar.dart';
import 'package:picple/presentation/home/view/home_page.dart';
import 'package:picple/presentation/login/view/login_page.dart';
import 'package:picple/presentation/profile/view/profile_page.dart';
import 'package:picple/presentation/profile_edit/view/profile_edit_page.dart';
import 'package:picple/presentation/setting/view/setting_page.dart';
import 'package:picple/presentation/shared/photo_detail/view/photo_detail_page.dart';
import 'package:picple/presentation/shared/photo_list/view/photo_list_page.dart';
import 'package:picple/presentation/splash/view/splash_page.dart';
import 'package:picple/presentation/upload/view/upload_page.dart';

enum Routes {
  splash(name: 'Splash', path: '/'),
  login(name: 'Login', path: '/login'),
  home(name: 'Home', path: '/home'),
  upload(name: 'Upload', path: '/upload'),

  photoDetail(name: 'PhotoDetail', path: '/photo_detail'),
  photoList(name: 'PhotoList', path: '/photo_list'),

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
      path: Routes.upload.path,
      builder: (context, state) => const UploadPage(),
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
      Routes.profile.path,
    ];

    return topLevelRoutes.contains(location);
  }

  @override
  Widget build(BuildContext context) {
    final showBottomBar = _isTopLevelRoute(context);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: showBottomBar
        ? PicpleBottomNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) {
              navigationShell.goBranch(index);
            },
            onUploadTap: () {
              context.push(Routes.upload.path);
            },
          )
        : null,
    );
  }
}