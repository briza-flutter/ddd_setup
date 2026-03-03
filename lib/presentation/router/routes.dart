import 'package:ddd_setup/presentation/pages/auth/login/login_page.dart';
import 'package:ddd_setup/presentation/pages/root/root_page.dart';
import 'package:go_router/go_router.dart';
import 'package:go_transitions/go_transitions.dart';

class Routes {
  static final root = "/root";
  static final login = "/login";
  static final _transitions = GoTransitions.cupertino;
  static final appRoutes = [
    GoRoute(
        path: root,
        builder: (context, state) => const RootPage(),
        pageBuilder: _transitions.call),
    GoRoute(
        path: login,
        builder: (context, state) => const LoginPage(),
        pageBuilder: _transitions.call)
  ];
}
