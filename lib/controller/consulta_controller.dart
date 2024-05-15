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
  Future<void> consultar(BuildContext context,
      ConsultaEquipamentoViewModel consultaViewModel) async {
    await DispositivoServices.verificarConexao().then((conectado) async {
      if (!conectado) {
        consultaViewModel.ocupado = false;
        Generic.snackBar(
            context: context,
            mensagem:
                'Sem conexão com a internet. Estabeleça uma conexão e tente novamente');

        return null;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      Sessao usuarioSessao = Sessao.getSession(prefs);

      await regraDeAcesso(usuarioSessao, context, consultaViewModel);
    });
  }

  Future<void> regraDeAcesso(Sessao usuarioSessao, BuildContext context,
      ConsultaEquipamentoViewModel model) async {
    //      if (usuarioSessao.regrasAcesso!.contains("ConsultaIntegrada")) {
    //   return await consulta(context, model);
    // }
    if (usuarioSessao.regrasAcesso!.contains("GerenciarEquipamentosSGIDTIv3")) {
      return await consulta(context, model);
    }

    Generic.snackBar(
      context: context,
      mensagem: "Erro - O usuário não possui permissões para essa ação.",
    );
  }

  Future<void> consulta(
      BuildContext context, ConsultaEquipamentoViewModel model) async {
    Response responseConsulta = await ConsultaService.consulta(model);

    if (responseConsulta.statusCode != 200) {
      if (responseConsulta.statusCode == 401) {
        Generic.snackBar(
          context: context,
          mensagem: "Erro - ${responseConsulta.statusMessage}",
        );

        return await Future.delayed(const Duration(seconds: 3))
            .then((_) => context.push(AppRouterName.login));
      }

      if (responseConsulta.statusCode == 422) {
        Generic.snackBar(
          context: context,
          mensagem: "Este Dado não existe na base de dados.",
        );
        return;
      }

      Generic.snackBar(
        context: context,
        mensagem: "Erro - ${responseConsulta.statusMessage}",
      );
      return;
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
