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

      if (response.statusCode == 200) {
        return Generic.snackBar(
            context: context,
            mensagem: "Uma nova senha foi enviada para seu e-mail");
      } else {
        _handleErrorResponse(context, response);
      }
    } catch (e) {
      // Tratamento de erro pode ser adicionado aqui
    }
  }

  static Future<void> pegarDadosDoUsuario(BuildContext context) async {
    try {
      await _verificarConexao(context);

      Response response = await UsuarioService.pegarDadosDoUsuario();

      SharedPreferences prefs = await SharedPreferences.getInstance();

      Dados.fromJson(response.data).setDados(prefs);
    } catch (e) {
      // Tratamento de erro pode ser adicionado aqui
    }
  }

  static Future<void> pegarDadosDoUsuarioPeloCpf(
      BuildContext context, String cpf) async {
    try {
      await _verificarConexao(context);

      Response response = await UsuarioService.pegarDadosPeloCpf(cpf);
      if (response.statusCode == 200) {
        if (response.data != null && response.data.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          Dados.fromJson(response.data[0]);
        }
      } else {
        _handleErrorResponse(context, response);
      }
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
    String mensagemErro;
    if (response.statusCode == 401) {
      Generic.snackBar(
        context: context,
        mensagem: "Usuário não autenticado ou token encerrado",
      );
      // Future.delayed(const Duration(seconds: 3)) TODO: TSTAR SE AINDA DÁ ERRO MESMO SEM O FUTURE
      //     .then((_) => {context.goNamed(AppRouterName.login)});
      context.goNamed(AppRouterName.login);
    }
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


// http://intradev.ssp.gov-se/api/intranet/Usuarios/Ativos