import 'package:ddd_setup/features/auth/presentation/pages/login_page.dart';
import 'package:ddd_setup/features/home/presentation/pages/home_page.dart';
import 'package:go_router/go_router.dart';
import 'package:go_transitions/go_transitions.dart';

class Routes {
  static final home = "/home";
  static final login = "/login";
  static final _transitions = GoTransitions.cupertino;
  static final appRoutes = [
    GoRoute(
        path: home,
        builder: (context, state) => const HomePage(),
        pageBuilder: _transitions.call),
    GoRoute(
        path: login,
        builder: (context, state) => const LoginPage(),
        pageBuilder: _transitions.call)
  ];
}
