import 'package:go_router/go_router.dart';
import 'package:suporte_dti/controller/home_controller.dart';
import 'package:suporte_dti/model/equipamento_model.dart';
import 'package:suporte_dti/model/levantamento_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/screens/delegacia_list.dart';
import 'package:suporte_dti/screens/equipamento_detalhe_screen.dart';
import 'package:suporte_dti/screens/levantamento_escrito_screen.dart';
import 'package:suporte_dti/screens/resultado_equipamento_consulta.dart';
import 'package:suporte_dti/screens/login_screen.dart';
import 'package:suporte_dti/screens/qr_code_resultado_screen.dart';
import 'package:suporte_dti/screens/qr_code_scanner_screen.dart';
import 'package:suporte_dti/screens/recuperar_senha.dart';
import 'package:suporte_dti/screens/resumo_levantamento.dart';
import 'package:suporte_dti/screens/search_screen.dart';
import 'package:suporte_dti/screens/delegacia_detalhe.dart';
import 'package:suporte_dti/viewModel/delegacias_view_model.dart';
import 'package:suporte_dti/viewModel/equipamento_view_model.dart';

class Rotas {
  Rotas();
  static final routers = GoRouter(
    initialLocation: AppRouterName.homeController,
    routes: [
      GoRoute(
        path: AppRouterName.login,
        builder: (context, state) => (const LoginScreen()),
      ),
      GoRoute(
        path: AppRouterName.searchScreen,
        builder: (context, state) => (const SearchScreen()),
      ),
      GoRoute(
        path: AppRouterName.homeController,
        builder: (context, state) {
          //LoginViewModel? loginViewModel = state.extra as LoginViewModel;
          //   String? nome = state.extra as String;
          return (const HomeControler());
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
          // String? nome = state.extra as String;
          return (const SearchScreen());
        },
      ),
      // GoRoute(
      //   name: 'qrcCodeResult',
      //   path: AppRouterName.qrCodeResult,
      //   builder: (context, state) => (QrCodeResult()),
      // ),

      GoRoute(
        name: 'delegaciaDetalhe',
        path: AppRouterName.delegaciaDetalhe,
        builder: (context, state) {
          final data = state.extra! as Map<String, dynamic>;
          return (DelegaciaDetalhe(
              model: data["model"], sigla: data["sigla"], nome: data["nome"]));
        },
      ),
      GoRoute(
        name: 'delegaciaLista',
        path: AppRouterName.delegaciaLista,
        builder: (context, state) {
          DelegaciasViewModel? model = state.extra as DelegaciasViewModel;
          return (DelegaciaListScreen(
            model: model,
          ));
        },
      ),

      GoRoute(
        name: 'resumoLevantamento',
        path: AppRouterName.resumoLevantamento,
        builder: (context, state) {
          return (const ResumoLevantamento());
        },
      ),
      GoRoute(
        name: 'qrcCodeResult',
        path: AppRouterName.qrCodeResult,
        builder: (context, state) => (const QrCodeResult()),
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
        path: AppRouterName.resultadoEquipamentoConsulta,
        builder: (context, state) {
          //LoginViewModel? loginViewModel = state.extra as LoginViewModel;
          EquipamentoViewModel? model = state.extra as EquipamentoViewModel;
          return (ResultadoEquipamentoConsultaScreen(model: model));
        },
      ),
    ],
  );
}
