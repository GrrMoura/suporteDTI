// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/model/itens_delegacia_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/services/delegacia_service.dart';
import 'package:suporte_dti/services/dispositivo_service.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';
import 'package:suporte_dti/viewModel/delegacias_view_model.dart';

class DelegaciaController {
  Future<void> buscarDelegacias(
      BuildContext context, DelegaciasViewModel model) async {
    await _verificarConexao(context);

    try {
      final response = await DelegaciaService.buscar(model);
      if (response.statusCode == 200) {
        _prepararModelDelegaciaParaAView(model, response);
      } else {
        _tratarErro(context, response);
      }
    } catch (e) {
      _tratarErroInesperado(context);
    }
  }

  void _prepararModelDelegaciaParaAView(
      DelegaciasViewModel model, Response response) {
    var itensDelegaciaModel = ItensDelegaciaModel.fromJson(response.data);
    model.itensDelegaciaModel!.delegacias
        .addAll(itensDelegaciaModel.delegacias);
    model.paginacao = itensDelegaciaModel.paginacao;
  }

  void _tratarErro(BuildContext context, Response response) {
    String mensagemErro;
    if (response.statusCode == 401) {
      Generic.snackBar(
        context: context,
        mensagem: "Usuário não autenticado ou token encerrado",
      );
      context.goNamed(AppRouterName.login);
    } else {
      if (response.data is List) {
        if (response.data.isNotEmpty && response.data[0] != null) {
          mensagemErro = response.data[0];
        } else {
          mensagemErro = response.statusMessage ?? 'Erro desconhecido';
        }
      } else {
        if (response.data == null || response.data == '') {
          mensagemErro = response.statusMessage ?? 'Erro desconhecido';
        } else {
          mensagemErro = response.data;
        }
      }
      return Generic.snackBar(context: context, mensagem: mensagemErro);
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

  void _tratarErroInesperado(BuildContext context) {
    Generic.snackBar(
      context: context,
      mensagem: "Erro inesperado",
    );
  }
}
