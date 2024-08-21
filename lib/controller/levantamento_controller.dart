// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    await _verificarConexao(context);

    Response response = await LevantamentoService.cadastrar(model);
    if (response.statusCode == 200) {
      return Generic.snackBar(
          context: context,
          tipo: AppName.sucesso,
          mensagem: "Levantamento cadastrado com sucesso");
    } else {
      _tratarErro(context, response);
    }
  }

  Future<List<Unidade>> buscarTop3UnidadesComMaisLevantamentos(
      BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String hoje = DateFormat('dd/MM/yyyy').format(DateTime.now());
    String? ultimaRequisicao = prefs.getString('ultimaRequisicao');

    if (ultimaRequisicao == hoje) {
      String? unidadesJson = prefs.getString('top3Unidades');

      if (unidadesJson != null) {
        List<dynamic> listaMapas = jsonDecode(unidadesJson);
        return Unidade.fromJsonTop3List(listaMapas);
      }
    } else {
      await _verificarConexao(context);
      Response response =
          await LevantamentoService.buscarTop3UnidadesComMaisLevantamentos();
      if (response.statusCode == 200) {
        if (response.data != null) {
          List<dynamic> listaMapas = response.data;
          List<Unidade> unidades = Unidade.fromJsonTop3List(listaMapas);
          await prefs.setString('top3Unidades',
              jsonEncode(unidades.map((u) => u.toJsonTop3()).toList()));
          await prefs.setString('ultimaRequisicao', hoje);
          return unidades;
        }
      } else {
        _tratarErro(context, response);
      }
    }
    return [];
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
//Levantamentos/UnidadesLevantamentos
      return null;
    } catch (e) {
      debugPrint("Erro inesperado: $e");

      return null;
    }
  }

  Future<String?> imprimirLevantamento(
      {required bool assinado,
      required BuildContext context,
      required int idLevantamento}) async {
    await _verificarConexao(context);

    try {
      Response response = await LevantamentoService.imprimirLevantamento(
          idLevantamento, assinado);

      if (response.statusCode == 200) {
        const uuid = Uuid();
        final fileName = '${uuid.v4()}.pdf';

        // final directory = await getExternalStorageDirectory();
        final downloadsDirectory = Directory('/storage/emulated/0/Download');
        if (!await downloadsDirectory.exists()) {
          await downloadsDirectory.create(recursive: true);
        }

        final filePath = '${downloadsDirectory.path}/$fileName';
        final file = File(filePath);

        final bytes = response.data is List<int>
            ? response.data
            : utf8.encode(response.data);

        await file.writeAsBytes(bytes);
        return filePath;
      } else {
        _tratarErro(context, response);
        return null;
      }
    } catch (e) {
      debugPrint("Erro inesperado: $e");
      return null;
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
      debugPrint("$e");
      return null;
    }
  }

  Future<void> levantamentoCadastrarAssinado(
      {required BuildContext context,
      required int idLevantamento,
      required int idUsuario,
      required String path}) async {
    await _verificarConexao(context);

    String data = DateFormat('dd/MM/yyyy').format(DateTime.now());

    String nomePDF = separarNome(path);

    FormData formData = FormData.fromMap({
      'idUsuarioAssinatura': idUsuario,
      'dataAssinatura': data,
      'idLevantamento': idLevantamento,
      'levantamentoAssinadoPdf':
          await MultipartFile.fromFile(path, filename: nomePDF),
    });
    try {
      Response response =
          await LevantamentoService.cadastrarLevantamentoAssinado(formData);

      if (response.statusCode == 200) {
        Generic.snackBar(
            context: context,
            mensagem: "Levantamento cadastrado com sucesso",
            tipo: AppName.sucesso);
      } else {
        _tratarErro(context, response);
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  String separarNome(String filePath) {
    List<String> parts = filePath.split('/');
    String fileName = parts.last;
    fileName.split('.').first;
    return fileName;
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

      return context.go(AppRouterName.login);
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
        } else if (response.data.toString().contains("<!DOCTYPE html>")) {
          mensagemErro = response.statusMessage ?? "Erro deseconhecido";
        } else {
          mensagemErro = response.data;
        }
      }
      return Generic.snackBar(context: context, mensagem: mensagemErro);
    }
  }
}
