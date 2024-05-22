import 'package:go_router/go_router.dart';
import 'package:suporte_dti/controller/home_controller.dart';
import 'package:suporte_dti/model/equipamento_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/screens/edite_screen.dart';
import 'package:suporte_dti/screens/equipamento_detalhe_screen.dart';
import 'package:suporte_dti/screens/levantamento_escrito_screen.dart';
import 'package:suporte_dti/screens/lista_equipamentos_consulta.dart';
import 'package:suporte_dti/screens/login_screen.dart';
import 'package:suporte_dti/screens/qr_code_resultado_screen.dart';
import 'package:suporte_dti/screens/qr_code_scanner_screen.dart';
import 'package:suporte_dti/screens/recuperar_senha.dart';
import 'package:suporte_dti/screens/resultado_screen.dart';
import 'package:suporte_dti/screens/resumo_levantamento.dart';
import 'package:suporte_dti/screens/search_screen.dart';
import 'package:suporte_dti/screens/delegacia_resultado_screen.dart';
import 'package:suporte_dti/viewModel/equipamento_view_model.dart';

class Rotas {
  Rotas();
  static final routers = GoRouter(
    initialLocation: AppRouterName.login,
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
        path: AppRouterName.detalhesEquipamento,
        builder: (context, state) {
          EquipamentoModel? model = state.extra as EquipamentoModel;
          return (EquipamentoDetalhe(equipamentoModel: model));
        },
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
        name: 'resumoLevantamento',
        path: AppRouterName.resumoLevantamento,
        builder: (context, state) => (const ResumoLevantamento()),
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
        builder: (context, state) => (const LevantamentoDigitado()),
      ),
      GoRoute(
        path: AppRouterName.qrCodeScanner,
        builder: (context, state) => (const QrCodeScanner()),
      ),
      GoRoute(
        path: AppRouterName.recuperarSenhaScreen,
        builder: (context, state) => (const RecuperarSenha()),
      ),
      GoRoute(
        path: AppRouterName.listaEquipamentos,
        builder: (context, state) {
          //LoginViewModel? loginViewModel = state.extra as LoginViewModel;
          EquipamentoViewModel? model = state.extra as EquipamentoViewModel;
          return (EquipamentoConsultaScreen(model: model));
        },
      ),
    ],
  );
}
