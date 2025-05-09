import 'package:go_router/go_router.dart';
import 'package:picple/presentation/home/view/home_page.dart';
import 'package:picple/presentation/login/view/login_page.dart';
import 'package:picple/presentation/splash/view/splash_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
  ],
);
