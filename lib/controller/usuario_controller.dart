// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/services/dispositivo_service.dart';
import 'package:suporte_dti/services/usuario_service.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';
import 'package:suporte_dti/viewModel/dados_usuario_view_model.dart';
import 'package:suporte_dti/viewModel/resetar_senha_view_model.dart';

class UsuarioController {
  static Future<void> resetarSenha(
      BuildContext context, ResetarSenhaViewModel model) async {
    try {
      await _verificarConexao(context);

      Response response = await UsuarioService.resetarSenha(model);

      if (response.statusCode != 200) {
        _handleErrorResponse(context, response);
        return;
      }

      model.esqueceuSenha = false;
      if (context.mounted) {
        Generic.snackBar(
          context: context,
          mensagem:
              "Instruções e uma nova senha foram enviadas para o e-mail ${model.email!.toLowerCase()}",
        );
      }
    } catch (e) {
      // Tratamento de erro pode ser adicionado aqui
    }
  }

  static Future<void> pegarDadosDoUsuario(BuildContext context) async {
    try {
      bool conectado = await DispositivoServices.verificarConexao();
      if (!conectado) {
        Generic.snackBar(
            context: context,
            mensagem:
                "Sem conexão com a internet. Estabeleça uma conexão e tente novamente.");
        return;
      }

      Response response = await UsuarioService.pegarDadosDoUsuario();

      SharedPreferences prefs = await SharedPreferences.getInstance();

      Dados.fromJson(response.data).setDados(prefs);
    } catch (e) {
      // Tratamento de erro pode ser adicionado aqui
    }
  }

  static Future<void> _verificarConexao(BuildContext context) async {
    bool conectado = await DispositivoServices.verificarConexao();
    if (!conectado) {
      Generic.snackBar(
        context: context,
        mensagem: "Sem conexão com a internet.",
      );
      throw Exception("Sem conexão com a internet.");
    }
  }

  static void _handleErrorResponse(BuildContext context, Response response) {
    if (response.statusCode == 422) {
      Generic.snackBar(
          context: context,
          mensagem:
              "Erro - Os dados informados não conferem com os dados cadastrados.");
    } else if (response.statusCode == 401) {
      Generic.snackBar(
        context: context,
        mensagem: "Usuário não autenticado ou token encerrado",
      );
      context.goNamed(AppRouterName.login);
    } else {
      Generic.snackBar(
          context: context, mensagem: "Erro - ${response.data[0]}");
    }
  }
}
