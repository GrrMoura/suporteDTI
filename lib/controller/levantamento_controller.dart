// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/model/itens_delegacia_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/services/delegacia_service.dart';
import 'package:suporte_dti/services/dispositivo_service.dart';
import 'package:suporte_dti/services/levantamento_service.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';
import 'package:suporte_dti/viewModel/delegacias_view_model.dart';

class LevantamentoController {
  Future<void> buscar(BuildContext context, DelegaciasViewModel model) async {
    await DispositivoServices.verificarConexao().then((conectado) async {
      if (!conectado) {
        Generic.snackBar(
          context: context,
          mensagem: "Sem conexão com a internet.",
        );
      }

      Response response = await DelegaciaService.buscar(model);

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
          return context.goNamed(AppRouterName.login);
        }
        Generic.snackBar(
            context: context, mensagem: "${response.statusMessage}");

        return;
      }
      pepararModelLevantamentoParaAView(model, response);
    });
  }

  void pepararModelLevantamentoParaAView(
      DelegaciasViewModel model, Response response) {
    var itensDelegaciaModel = ItensDelegaciaModel.fromJson(response.data);

    model.itensDelegaciaModel!.delegacias
        .addAll(itensDelegaciaModel.delegacias);
    model.paginacao = itensDelegaciaModel.paginacao;
  }

  Future<void> cadastrar(
      BuildContext context, DelegaciasViewModel model) async {
    await DispositivoServices.verificarConexao().then((conectado) async {
      if (!conectado) {
        Generic.snackBar(
          context: context,
          mensagem: "Sem conexão com a internet.",
        );
      }

      Response response = await LevantamentoService.cadastrar(model);

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
          return context.goNamed(AppRouterName.login);
        }
        Generic.snackBar(
            context: context, mensagem: "${response.statusMessage}");

        return;
      }
      pepararModelLevantamentoParaAView(model, response);
    });
  }
}
