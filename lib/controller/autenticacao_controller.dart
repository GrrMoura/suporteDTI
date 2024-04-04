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
    await DispositivoServices.verificarConexao().then((conectado) async {
      model.ocupado = true;
      if (!conectado) {
        model.ocupado = false;

        Generic.snackBar(
            context: context,
            conteudo:
                'Sem conexão com a internet. Estabeleça uma conexão e tente novamente');

        return null;
      }

      Response response = await AutenticacaoService.logar(model);

      if (response.statusCode != 200) {
        model.ocupado = false;
        if (response.statusCode == 422) {
          Generic.snackBar(
              context: context, conteudo: ' Erro - ${response.data[0]}');

          return null;
        }

        Generic.snackBar(
            context: context, conteudo: ' Erro - ${response.statusMessage}');

        return null;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();

      Sessao.fromJson(response.data).setSession(prefs, model);

      //   model.ocupado = false;

      LoginController.setCpf(model.login!);
      LoginController.setSenha(model.senha!);
      prefs.setBool("lembrar_me", model.lembrarMe!);

      String fullName = response.data['usuario'];
      List names = fullName.split(' ');
      String primeiroNome = names[0];

      String segundoNome = names[names.length - 1];
      String cpf = model.login!;
      String dados = "$primeiroNome $segundoNome $cpf";

      context.go(AppRouterName.homeController, extra: dados);
    });
  }

  Future<Sessao> getSessao() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Sessao sessao = Sessao.getSession(prefs);
    return sessao;
  }

  static Future<void> limparSessao() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", "");
    prefs.setInt("id", 0);
    prefs.setBool("alterarSenha", false);
    prefs.setStringList("regrasAcesso", []);
  }
}
