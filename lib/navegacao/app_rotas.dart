import 'package:go_router/go_router.dart';
import 'package:suporte_dti/controller/home_controller.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/screens/edite_screen.dart';
import 'package:suporte_dti/screens/equipamento_detalhe_screen.dart';
import 'package:suporte_dti/screens/levantamento_escrito_screen.dart';
import 'package:suporte_dti/screens/login_screen.dart';
import 'package:suporte_dti/screens/qr_code_resultado_screen.dart';
import 'package:suporte_dti/screens/resultado_screen.dart';
import 'package:suporte_dti/screens/search_screen.dart';
import 'package:suporte_dti/screens/delegacia_resultado_screen.dart';
import 'package:suporte_dti/viewModel/login_view_model.dart';

class Rotas {
  Rotas();
  static final routers = GoRouter(
    initialLocation: AppRouterName.levantamentoDigitadoScreen,
    routes: [
      GoRoute(
        path: AppRouterName.login,
        builder: (context, state) => (const LoginScreen()),
      ),
      GoRoute(
        path: AppRouterName.searchScreen,
        builder: (context, state) => (const SearchScreen(
          nome: "aaaa",
        )),
      ),
      GoRoute(
        path: AppRouterName.homeController,
        builder: (context, state) {
          //LoginViewModel? loginViewModel = state.extra as LoginViewModel;
          String? nome = state.extra as String;
          return (HomeControler(nome: nome));
        },
      ),
      GoRoute(
        path: AppRouterName.resultado,
        builder: (context, state) {
          return ResultadoScreen();
        },
      ),
      GoRoute(
        path: AppRouterName.detalhe,
        builder: (context, state) => (const EquipamentoDetalhe()),
      ),
      GoRoute(
        path: AppRouterName.search,
        builder: (context, state) {
          // LoginViewModel? loginViewModel = state.extra as LoginViewModel;
          String? nome = state.extra as String;
          return (SearchScreen(
            nome: nome,
          ));
        },
      ),
      // GoRoute(
      //   name: 'qrcCodeResult',
      //   path: AppRouterName.qrCodeResult,
      //   builder: (context, state) => (QrCodeResult()),
      // ),
      GoRoute(
        name: 'resultDelegacia',
        path: AppRouterName.resultDelegacias,
        builder: (context, state) => (const ResultDelegacia()),
      ),
      GoRoute(
        name: 'qrcCodeResult',
        path: AppRouterName.qrCodeResult,
        builder: (context, state) => (const QrCodeResult()),
      ),
      GoRoute(
        name: 'updateScreen',
        path: AppRouterName.updateScreen,
        builder: (context, state) => (UpdateScreen()),
      ),
      GoRoute(
        path: AppRouterName.levantamentoDigitadoScreen,
        builder: (context, state) => (LevantamentoDigitado()),
      ),
    ],
  );
}
