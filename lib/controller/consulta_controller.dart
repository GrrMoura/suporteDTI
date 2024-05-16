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
import 'package:suporte_dti/viewModel/equipamento_view_model.dart';

class ConsultaController {
  Future<void> consultarEquipamentos(
      BuildContext context, EquipamentoViewModel equipamentoViewModel) async {
    await DispositivoServices.verificarConexao().then((conectado) async {
      if (!conectado) {
        equipamentoViewModel.ocupado = false;
        Generic.snackBar(
            context: context,
            mensagem:
                'Sem conexão com a internet. Estabeleça uma conexão e tente novamente');

        return null;
      }

      if (equipamentoViewModel.paginacao != null &&
          !equipamentoViewModel.paginacao!.seChegouAoFinalDaPagina()) {
        equipamentoViewModel.paginacao?.setProximaPagina();
      }

      Response responseConsulta =
          await ConsultaService.consulta(equipamentoViewModel);

      if (responseConsulta.statusCode != 200) {
        if (responseConsulta.statusCode == 401) {
          Generic.snackBar(
            context: context,
            mensagem: "Erro - ${responseConsulta.statusMessage}",
          );

          return await Future.delayed(const Duration(seconds: 3))
              .then((_) => context.push(AppRouterName.login));
          //TODO: TESTAR SE ESTA LIMPANDO A PILHA DE PAGINA
        }

        if (responseConsulta.statusCode == 422) {
          Generic.snackBar(
            context: context,
            mensagem: "Nenhum resultado encontrado.",
          );
          return null;
        }

        Generic.snackBar(
          context: context,
          mensagem: "Erro - ${responseConsulta.statusMessage}",
        );
        return null;
      }
      EquipamentosModel equipamentosModel =
          EquipamentosModel.fromJson(responseConsulta.data);

      prepararModelEquipamentosParaAView(
          equipamentoViewModel, responseConsulta);

      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => ResultadoScreen(model: equipamentosModel),
      //   ),
      // );

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // Sessao usuarioSessao = Sessao.getSession(prefs);

      // await regraDeAcesso(usuarioSessao, context, consultaViewModel);
    });
  }

  void prepararModelEquipamentosParaAView(
      EquipamentoViewModel model, Response response) {
    var equipamentosConsultaModel = EquipamentosModel.fromJson(response.data);
    if (model.equipamentos!.isEmpty) {
      model.equipamentos = [];
    }
    model.equipamentos!.addAll(equipamentosConsultaModel);
    model.paginacao = equipamentosConsultaModel.paginacao;
  }

  Future<void> regraDeAcesso(Sessao usuarioSessao, BuildContext context,
      EquipamentoViewModel model) async {
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
      BuildContext context, EquipamentoViewModel model) async {}
}
