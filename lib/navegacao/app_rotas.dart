import 'package:go_router/go_router.dart';
import 'package:suporte_dti/controller/home_controller.dart';
import 'package:suporte_dti/navegacao/app_screens_string.dart';
import 'package:suporte_dti/screens/equipamento_detalhe_screen.dart';
import 'package:suporte_dti/screens/login_screen.dart';
import 'package:suporte_dti/screens/qrcode_resultado_screen.dart';
import 'package:suporte_dti/screens/resultado_screen.dart';
import 'package:suporte_dti/screens/search_screen.dart';
import 'package:suporte_dti/screens/delegacia_resultado_screen.dart';

class Rotas {
  Rotas();
  static final routers = GoRouter(
    initialLocation: AppRouterName.qrCodeResult,
    routes: [
      GoRoute(
        name: 'login',
        path: AppRouterName.login,
        builder: (context, state) => (const LoginScreen()),
      ),
      GoRoute(
        name: 'homeController',
        path: AppRouterName.homeController,
        builder: (context, state) => (const HomeControler()),
      ),
      GoRoute(
        name: 'resultado',
        path: AppRouterName.resultado,
        builder: (context, state) => (ResultadoScreen()),
      ),
      GoRoute(
        name: 'detalhe',
        path: AppRouterName.detalhe,
        builder: (context, state) => (const EquipamentoDetalhe()),
      ),
      GoRoute(
        name: 'search',
        path: AppRouterName.search,
        builder: (context, state) => (const SearchScreen()),
      ),
      // GoRoute(
      //   name: 'qrcCodeResult',
      //   path: AppRouterName.qrCodeResult,
      //   builder: (context, state) => (QrCodeResult()),
      // ),
      GoRoute(
        name: 'resultDelegacia',
        path: AppRouterName.resultDelegacias,
        builder: (context, state) => (ResultDelegacia()),
      ),
      GoRoute(
        name: 'qrcCodeResult',
        path: AppRouterName.qrCodeResult,
        builder: (context, state) => (QrCodeResult()),
      ),
    ],
  );
}
