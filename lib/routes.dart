import 'package:go_router/go_router.dart';
import 'package:picple/presentation/home/view/home_page.dart';
import 'package:picple/presentation/login/view/login_page.dart';
import 'package:picple/presentation/splash/view/splash_page.dart';

enum Routes {
  splash(name: 'Splash', path: '/'),
  home(name: 'Home', path: '/home'),
  login(name: 'Login', path: '/login');

  final String name;
  final String path;

  const Routes({required this.name, required this.path});
}

final router = GoRouter(
  routes: [
    GoRoute(path: Routes.splash.path, builder: (context, state) => const SplashPage()),
    GoRoute(path: Routes.home.path, builder: (context, state) => const HomePage()),
    GoRoute(path: Routes.login.path, builder: (context, state) => const LoginPage()),
  ],
);
