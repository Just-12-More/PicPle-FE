import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picple/presentation/component/picple_bottom_navigation_bar.dart';
import 'package:picple/presentation/home/view/home_page.dart';
import 'package:picple/presentation/login/view/login_page.dart';
import 'package:picple/presentation/profile/view/profile_page.dart';
import 'package:picple/presentation/profile_edit/view/profile_edit_page.dart';
import 'package:picple/presentation/setting/view/setting_page.dart';
import 'package:picple/presentation/shared/view/photo_list_page.dart';
import 'package:picple/presentation/splash/view/splash_page.dart';
import 'package:picple/presentation/upload/view/upload_page.dart';

enum Routes {
  splash(name: 'Splash', path: '/'),
  login(name: 'Login', path: '/login'),
  home(name: 'Home', path: '/home'),
  upload(name: 'Upload', path: '/upload'),
  profile(name: 'Profile', path: '/profile'),
  profileEdit(name: 'ProfileEdit', path: '/profile_edit'),
  setting(name: 'Setting', path: '/setting'),
  photoList(name: 'PhotoList', path: '/photo_list');

  final String name;
  final String path;

  const Routes({required this.name, required this.path});
}

final router = GoRouter(
  initialLocation: Routes.login.path,
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
      path: Routes.setting.path,
      builder: (context, state) => const SettingPage(),
    ),
    GoRoute(
      path: Routes.photoList.path,
      builder: (context, state) => const PhotoListPage(),
    ),
    GoRoute(
      path: Routes.profileEdit.path,
      builder: (context, state) => const ProfileEditPage(),
    ),

    GoRoute(
        path: Routes.upload.path,
        builder: (context, state) => const UploadPage(),
        routes: []
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
                  routes: []
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: PicpleBottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(index);
        },
        onUploadTap: () {
          context.push(Routes.upload.path);
        },
      )
    );
  }
}