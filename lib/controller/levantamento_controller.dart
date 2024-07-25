// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:suporte_dti/data/sqflite_helper.dart';
import 'package:suporte_dti/model/levantamento_cadastrados_model.dart';
import 'package:suporte_dti/model/levantamento_detalhe.dart';
import 'package:suporte_dti/model/levantamento_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/services/dispositivo_service.dart';
import 'package:suporte_dti/services/levantamento_service.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';
import 'package:uuid/uuid.dart';

class LevantamentoController {
  Future<void> cadastrar(BuildContext context, LevantamentoModel model) async {
    final DatabaseHelper dbHelper = DatabaseHelper();
    await _verificarConexao(context);

    Response response = await LevantamentoService.cadastrar(model);
    if (response.statusCode == 200) {
      dbHelper.deleteAllEquipamentos();
      context.pop("value");
      return Generic.snackBar(
          context: context,
          tipo: AppName.sucesso,
          mensagem: "Levantamento cadastrado com sucesso");
    }
  }

  Future<LevantamentocadastradoModel?> buscarLevantamentoPorIdUnidade(
      BuildContext context, LevantamentoModel model) async {
    await _verificarConexao(context);
    LevantamentocadastradoModel levantamentocadastradoModel =
        LevantamentocadastradoModel();

    try {
      Response response =
          await LevantamentoService.buscarLevantamentoPorIdUnidade(model);
      if (response.statusCode == 200) {
        if (response.data['cadastrados'].isNotEmpty) {
          _updateModelFromResponse(levantamentocadastradoModel, response);
          return levantamentocadastradoModel;
        }
      } else {
        _tratarErro(context, response);
      }

      return null;
    } catch (e) {
      debugPrint("Erro inesperado: $e");

      return null;
    }
  }

  Future<String?> imprimirLevantamento(
      BuildContext context, int idLevantamento) async {
    await _verificarConexao(context);
    print("cliquei no down");
    try {
      Response response =
          await LevantamentoService.imprimirLevantamento(idLevantamento);

      if (response.statusCode == 200) {
        const uuid = Uuid();
        final fileName = '${uuid.v4()}.pdf'; // Nome do arquivo com UUID

        // Obtenha o diretório de armazenamento externo
        final directory = await getExternalStorageDirectory();
        final downloadDirectory = Directory('${directory?.path}/Download');
        if (!await downloadDirectory.exists()) {
          await downloadDirectory.create(recursive: true);
        }

        final filePath = '${downloadDirectory.path}/$fileName';
        final file = File(filePath);

        // Assuma que a resposta é de tipo List<int>
        final bytes = response.data is List<int>
            ? response.data
            : utf8.encode(response.data); // Converte se necessário

        try {
          await file.writeAsBytes(bytes);
          print('Arquivo salvo em: $filePath');
          // Retorne o nome do arquivo para uso posterior
          return fileName;
        } catch (e) {
          debugPrint("Erro ao salvar o arquivo: $e");
          return null;
        }
      } else {
        _tratarErro(context, response);
        return null;
      }
    } catch (e) {
      debugPrint("Erro inesperado: $e");
      return null;
    }
  }

  Future<void> downloadLevantamentoAssinado(
      BuildContext context, int idLevantamento) async {
    await _verificarConexao(context);

    try {
      Response response =
          await LevantamentoService.imprimirLevantamento(idLevantamento);
      if (response.statusCode == 200) {
        return;
      } else {
        _tratarErro(context, response);
      }
    } catch (e) {
      debugPrint("Erro inesperado: $e");
    }
  }

  Future<DetalheLevantamentoModel?> levantamentoDetalhe(
      BuildContext context, int idLevantamento) async {
    await _verificarConexao(context);

    try {
      Response response =
          await LevantamentoService.levantamentoDetalhe(idLevantamento);

      if (response.statusCode == 200) {
        DetalheLevantamentoModel levantamentoModel =
            DetalheLevantamentoModel.fromJson(response.data);

        return levantamentoModel;
      } else {
        _tratarErro(context, response);

        return null;
      }
    } catch (e) {
      // Trate erros genéricos
      Generic.snackBar(
        context: context,
        mensagem: "Erro inesperado",
      );
      return null;
    }
  }

  void _updateModelFromResponse(
      LevantamentocadastradoModel model, Response response) {
    var itensLevantamentoModel =
        LevantamentocadastradoModel.fromJson(response.data);

    if (itensLevantamentoModel.cadastrados != null &&
        itensLevantamentoModel.cadastrados!.isNotEmpty) {
      model.cadastrados ??= [];
      model.cadastrados!.addAll(itensLevantamentoModel.cadastrados!);
    }

    model.paginacao = itensLevantamentoModel.paginacao;
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

  void _tratarErro(BuildContext context, Response response) {
    String mensagemErro;
    if (response.statusCode == 401) {
      Generic.snackBar(
        context: context,
        mensagem: "Usuário não autenticado ou token encerrado",
      );
      // Future.delayed(const Duration(seconds: 3)) TODO: TSTAR SE AINDA DÁ ERRO MESMO SEM O FUTURE
      //     .then((_) => {context.goNamed(AppRouterName.login)});
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
}
