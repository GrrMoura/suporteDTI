// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suporte_dti/model/equipamentos_model.dart';
import 'package:suporte_dti/model/sessao_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/screens/resultado_screen.dart';
import 'package:suporte_dti/services/consulta_service.dart';
import 'package:suporte_dti/services/dispositivo_service.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';
import 'package:suporte_dti/viewModel/consulta_view_model.dart';

class ConsultaController {
  Future<void> consultar(
      BuildContext context, ConsultaViewModel consultaViewModel) async {
    await DispositivoServices.verificarConexao().then((conectado) async {
      consultaViewModel.ocupado = true;

      if (!conectado) {
        consultaViewModel.ocupado = false;
        Generic.snackBar(
            context: context,
            conteudo:
                'Sem conexão com a internet. Estabeleça uma conexão e tente novamente');

        return null;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      Sessao usuarioSessao = Sessao.getSession(prefs);

      await regraDeAcesso(usuarioSessao, context, consultaViewModel);

      consultaViewModel.ocupado = false;
    });
  }

  Future<void> regraDeAcesso(Sessao usuarioSessao, BuildContext context,
      ConsultaViewModel model) async {
    //      if (usuarioSessao.regrasAcesso!.contains("ConsultaIntegrada")) {
    //   return await consulta(context, model);
    // }
    if (usuarioSessao.regrasAcesso!.contains("")) {
      return await consulta(context, model);
    }

    Generic.snackBar(
        context: context,
        conteudo: "Erro - O usuário não possui permissões para essa ação.",
        barBehavior: SnackBarBehavior.floating);
  }

  Future<void> consulta(BuildContext context, ConsultaViewModel model) async {
    Response responseConsulta = await ConsultaService.consulta(model);

    if (responseConsulta.statusCode != 200) {
      model.ocupado = false;

      if (responseConsulta.statusCode == 401) {
        Generic.snackBar(
            context: context,
            conteudo: "Erro - ${responseConsulta.statusMessage}",
            barBehavior: SnackBarBehavior.floating);

        return await Future.delayed(const Duration(seconds: 3))
            .then((_) => context.push(AppRouterName.login));
      }

      if (responseConsulta.statusCode == 422) {
        Generic.snackBar(
            context: context,
            conteudo: "Este Dado não existe na base de dados.",
            barBehavior: SnackBarBehavior.floating);
      }
      Generic.snackBar(
          context: context,
          conteudo: "Erro - ${responseConsulta.statusMessage}",
          barBehavior: SnackBarBehavior.floating);
    }
    EquipamentosModel equipamentosModel =
        EquipamentosModel.fromJson(responseConsulta.data);
    model.ocupado = false;

    // context.push(AppRouterName.resultado);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResultadoScreen(model: equipamentosModel),
      ),
    );
  }
}
