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
  static Future resetarSenha(
      BuildContext context, ResetarSenhaViewModel model) async {
    await DispositivoServices.verificarConexao().then((conectado) async {
      if (!conectado) {
        Generic.snackBar(
            context: context,
            mensagem:
                "Sem conexão com a internet. Estabeleça uma conexão e tente novamente.");
        return;
      }

      Response response = await UsuarioService.resetarSenha(model);

      if (response.statusCode != 200 && context.mounted) {
        if (response.statusCode == 422) {
          return Generic.snackBar(
              context: context,
              mensagem:
                  "Erro - Os dados informados não conferem com os dados cadastrados.");
        }

        if (response.statusCode == 401) {
          Generic.snackBar(
            context: context,
            mensagem: "Usuário não autenticado ou token encerrado",
          );

          return context.go(AppRouterName.login);
        }
        Generic.snackBar(
            context: context, mensagem: "Erro - ${response.statusMessage}");
        return;
      }
      model.esqueceuSenha = false;
      if (context.mounted) {
        Generic.snackBar(
          context: context,
          mensagem:
              "Instruções e uma nova senha foram enviadas para o e-mail ${model.email!.toLowerCase()}",
        );
        return;
      }
    });
  }

  static Future pegarDadosDoUsuario(BuildContext context) async {
    await DispositivoServices.verificarConexao().then((conectado) async {
      if (!conectado) {
        Generic.snackBar(
            context: context,
            mensagem:
                "Sem conexão com a internet. Estabeleça uma conexão e tente novamente.");
        return null;
      }

      Response response = await UsuarioService.pegarDadosDoUsuario();

      SharedPreferences prefs = await SharedPreferences.getInstance();

      Dados.fromJson(response.data).setDados(prefs);
      return null;
    });
    return null;
  }
}
