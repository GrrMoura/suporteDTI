// ignore_for_file: use_build_context_synchronously

import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suporte_dti/model/equipamentos_model.dart';
import 'package:suporte_dti/model/sessao_model.dart';
import 'package:suporte_dti/navegacao/app_screens_string.dart';
import 'package:suporte_dti/screens/resultado_screen.dart';
import 'package:suporte_dti/services/consulta_service.dart';
import 'package:suporte_dti/services/dispositivo_service.dart';
import 'package:suporte_dti/viewModel/consulta_view_model.dart';

class ConsultaController {
  Future<void> consultar(BuildContext context, ConsultaViewModel model) async {
    await DispositivoServices.verificarConexao().then((conectado) async {
      //   Loader.show(context);

      if (!conectado) {
        // Loader.hide();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Erro - Sem conexão com a internet")));

        return null;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      Sessao usuarioSessao = Sessao.getSession(prefs);

      await regraDeAcesso(usuarioSessao, context, model);

      //  Loader.hide();
    });
  }

  Future<void> regraDeAcesso(Sessao usuarioSessao, BuildContext context,
      ConsultaViewModel model) async {
    if (usuarioSessao.regrasAcesso!.contains("ConsultaIntegrada")) {
      return await consulta(context, model);
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text("Erro - O usuário não possui permissões para essa ação.")));
  }

  Future<void> consulta(BuildContext context, ConsultaViewModel model) async {
    Response responseConsulta = await ConsultaService.consulta(model);

    if (responseConsulta.statusCode != 200) {
      //Loader.hide();
      if (responseConsulta.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Erro - ${responseConsulta.statusMessage}")));

        return await Future.delayed(const Duration(seconds: 3))
            .then((_) => context.push(AppRouterName.login));
      }

      if (responseConsulta.statusCode == 422) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Este Dado não existe na base de dados.")));
      }
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro - ${responseConsulta.statusMessage}")));
    }
    EquipamentosModel equipamentosModel =
        EquipamentosModel.fromJson(responseConsulta.data);
    //  Loader.hide();

    context.push(AppRouterName.resultado);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResultadoScreen(model: equipamentosModel),
      ),
    );
  }
}
