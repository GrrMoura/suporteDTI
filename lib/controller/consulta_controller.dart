// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/model/equipamento_model.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/services/consulta_service.dart';
import 'package:suporte_dti/services/dispositivo_service.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';
import 'package:suporte_dti/viewModel/equipamento_view_model.dart';

class ConsultaController {
  Future<void> buscarEquipamentos(
      BuildContext context, EquipamentoViewModel model) async {
    await DispositivoServices.verificarConexao().then((conectado) async {
      if (!conectado) {
        Generic.snackBar(
          context: context,
          mensagem: "Sem conexão com a internet.",
        );
        return null;
      }
      if (model.paginacao != null &&
          !model.paginacao!.seChegouAoFinalDaPagina()) {
        model.paginacao!.setProximaPagina();
      }
      Response responseConsulta =
          await ConsultaService.buscarEquipamentos(model);

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
          return null;
        }

        Generic.snackBar(
          context: context,
          mensagem: "Erro - ${responseConsulta.data[0]}",
        );
        return null;
      }

      pepararModelEquipamentoParaAView(model, responseConsulta);
    });
  }

  void pepararModelEquipamentoParaAView(
      EquipamentoViewModel model, Response response) {
    var itensEquipamentoModel = ItensEquipamentoModels.fromJson(response.data);
    // ignore: prefer_conditional_assignment

    model.itensEquipamentoModels.equipamentos
        .addAll(itensEquipamentoModel.equipamentos);
    model.paginacao = itensEquipamentoModel.paginacao;
  }

  Future<void> buscarEquipamentoPorId(
      BuildContext context, ItemEquipamento model) async {
    await DispositivoServices.verificarConexao().then((conectado) async {
      if (!conectado) {
        Generic.snackBar(
          context: context,
          mensagem: "Sem conexão com a internet.",
        );
      }

      Response response = await ConsultaService.consultaEquipamentoPorId(model);

      if (response.statusCode != 200) {
        if (response.statusCode == 422) {
          Generic.snackBar(
            context: context,
            tipo: AppName.info,
            mensagem: "Nenhum resultado encontrado",
          );
        }

        if (response.statusCode == 401) {
          Generic.snackBar(
            context: context,
            mensagem: "Usuário não autenticado ou token encerrado",
          );
          await Future.delayed(const Duration(
                  seconds:
                      3)) //TODO: testar se limpa a stack de paginas e colocar na pagina router pra elmbar
              .then((_) => {context.goNamed(AppRouterName.login)});
        }
        Generic.snackBar(
          context: context,
          mensagem: "${response.statusMessage}",
        );

        return null;
      }

      EquipamentoModel equipamentoModel =
          EquipamentoModel.fromJson(response.data["detalhes"]);

      context.push(AppRouterName.detalhesEquipamento, extra: equipamentoModel);
    });
  }
}
