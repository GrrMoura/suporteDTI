import 'package:go_router/go_router.dart';
import 'package:suporte_dti/controller/home_controller.dart';
import 'package:suporte_dti/navegacao/app_screens_string.dart';
import 'package:suporte_dti/screens/login_screen.dart';

class Rotas {
  Rotas();
  static final routers = GoRouter(
    initialLocation: AppRouterName.homeController,
    routes: [
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => (const LoginScreen()),
      ),
      GoRoute(
        name: 'homeController',
        path: '/homeController',
        builder: (context, state) => (const HomeControler()),
      ),
    ],
  );
}
