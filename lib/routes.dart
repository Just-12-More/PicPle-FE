import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picple/presentation/component/picple_bottom_navigation_bar.dart';
import 'package:picple/presentation/home/view/home_page.dart';
import 'package:picple/presentation/login/view/login_page.dart';
import 'package:picple/presentation/splash/view/splash_page.dart';

enum Routes {
  splash(name: 'Splash', path: '/'),
  login(name: 'Login', path: '/login'),
  home(name: 'Home', path: '/home'),
  upload(name: 'Upload', path: '/upload'),
  profile(name: 'Profile', path: '/profile');

  final String name;
  final String path;

  const Routes({required this.name, required this.path});
}

final router = GoRouter(
  initialLocation: Routes.home.path,
  routes: [
    GoRoute(
      path: Routes.splash.path,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: Routes.login.path,
      builder: (context, state) => const LoginPage(),
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
                  path: Routes.upload.path,
                  builder: (context, state) => const HomePage(),
                  routes: []
              ),
            ]
        ),
        StatefulShellBranch(
            routes: [
              GoRoute(
                  path: Routes.profile.path,
                  builder: (context, state) => const HomePage(),
                  routes: []
              ),
            ]
        ),
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
          }
      )
    );
  }
}