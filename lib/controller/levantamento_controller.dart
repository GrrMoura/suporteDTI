// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/model/levantamento_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/services/dispositivo_service.dart';
import 'package:suporte_dti/services/levantamento_service.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';

class LevantamentoController {
  Future<void> cadastrar(BuildContext context, LevantamentoModel model) async {
    await _verificarConexao(context);
    Response response = await LevantamentoService.cadastrar(model);
    _handleResponse(context, response);
  }

  //colocar essa função em equipamento
  Future<void> verificarEquipamento(
      BuildContext context, LevantamentoModel model) async {
    await _verificarConexao(context);
    Response response = await LevantamentoService.verificarEquipamento(model);
    if (response.statusCode == 200) {
      return;
    }
    _handleResponse(context, response);
    if (response.statusCode == 401) {
      context.go(AppRouterName.login);
    }
  }

  Future<void> buscarLevantamentoPorIdUnidade(
      BuildContext context, LevantamentoModel model) async {
    await _verificarConexao(context);
    Response response =
        await LevantamentoService.buscarLevantamentoPorIdUnidade(model);
    if (response.statusCode == 200) {
      return;
    }
    _handleResponse(context, response);
    if (response.statusCode == 401) {
      context.go(AppRouterName.login);
    }
  }

  Future<void> _verificarConexao(BuildContext context) async {
    if (!await DispositivoServices.verificarConexao()) {
      Generic.snackBar(
        context: context,
        mensagem: "Sem conexão com a internet.",
      );
      throw Exception("Sem conexão com a internet.");
    }
  }

  void _handleResponse(BuildContext context, Response response) {
    if (response.statusCode == 200) {
      return;
    }

    if (response.statusCode == 422) {
      Generic.snackBar(
        context: context,
        tipo: AppName.info,
        mensagem: "Nenhum resultado encontrado",
      );
    } else if (response.statusCode == 401) {
      Generic.snackBar(
        context: context,
        mensagem: "Usuário não autenticado ou token encerrado",
      );
      context.goNamed(AppRouterName.login);
    } else {
      Generic.snackBar(
        context: context,
        mensagem: "${response.statusMessage}",
      );
    }
  }
}
