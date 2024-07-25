// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suporte_dti/controller/login_controller.dart';
import 'package:suporte_dti/model/sessao_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/services/autenticacao_service.dart';
import 'package:suporte_dti/services/dispositivo_service.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';
import 'package:suporte_dti/viewModel/login_view_model.dart';

class AutenticacaoController {
  Future<void> logar(BuildContext context, LoginViewModel model) async {
    model.ocupado = true;
    await _verificarConexao(context);

    try {
      Response response = await AutenticacaoService.logar(model);

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Sessao.fromJson(response.data).setSession(prefs, model);

        LoginController.setCpf(model.login!);
        LoginController.setSenha(model.senha!);
        prefs.setBool("lembrar_me", model.lembrarMe!);

        String fullName = response.data['usuario'];
        List<String> names = fullName.split(' ');
        String primeiroNome = names[0];
        String segundoNome = names.length > 1 ? names.last : '';

        String dados = "$primeiroNome $segundoNome ${model.login!}";
        prefs.setString("nome", primeiroNome);
        prefs.setString("segundoNome", segundoNome);
        prefs.setInt("idUsuario", response.data["id"]);

        context.go(AppRouterName.homeController, extra: dados);
      } else {
        _tratarErrorResponse(context, model, response);
      }
    } catch (e) {
      model.ocupado = false;
      Generic.snackBar(
        context: context,
        mensagem: 'Erro ao fazer login: $e',
      );
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

  void _tratarErrorResponse(
      BuildContext context, LoginViewModel model, Response response) {
    model.ocupado = false;
    String mensagemErro;

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

    Generic.snackBar(
      context: context,
      mensagem: mensagemErro,
    );
  }

  Future<Sessao> getSessao() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Sessao.getSession(prefs);
  }

  static Future<void> limparSessao() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
