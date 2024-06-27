// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/model/equipamento_model.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/services/equipamento_service.dart';
import 'package:suporte_dti/services/dispositivo_service.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';
import 'package:suporte_dti/viewModel/equipamento_view_model.dart';

class EquipamentoController {
  Future<void> buscarEquipamentos(
      BuildContext context, EquipamentoViewModel model) async {
    await DispositivoServices.verificarConexao().then((conectado) async {
      if (!conectado) {
        Generic.snackBar(
          context: context,
          mensagem: "Sem conexão com a internet.",
        );
        return;
      }
      if (model.paginacao != null &&
          !model.paginacao!.seChegouAoFinalDaPagina(model.paginacao!.pagina!)) {
        model.paginacao!.pagina = model.paginacao!.setProximaPagina(
            model.paginacao!.pagina!, model.paginacao!.totalPaginas!);
      }

      Response responseConsulta = await EquipamentoService.buscar(model);

      if (responseConsulta.statusCode != 200) {
        if (responseConsulta.statusCode == 401) {
          Generic.snackBar(
            context: context,
            mensagem: "Erro - ${responseConsulta.statusMessage}",
          );

          return context.go(AppRouterName.login);
          // return await Future.delayed(const Duration(seconds: 2)).then(
          //   (_) => context.go(AppRouterName.login),
          // );
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
          mensagem: "Erro - ${responseConsulta.data[0]}",
        );
        return;
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

      Response response = await EquipamentoService.buscarPorId(model);

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
          await Future.delayed(const Duration(seconds: 3))
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
