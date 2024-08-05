// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/model/equipamento_model.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/services/equipamento_service.dart';
import 'package:suporte_dti/services/dispositivo_service.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';
import 'package:suporte_dti/viewModel/equipamento_verificado_view_model.dart';
import 'package:suporte_dti/viewModel/equipamento_view_model.dart';

class EquipamentoController {
  Future<void> buscarEquipamentos(
      BuildContext context, EquipamentoViewModel model) async {
    await _verificarConexao(context);

    if (model.paginacao != null &&
        !model.paginacao!.seChegouAoFinalDaPagina(model.paginacao!.pagina!)) {
      model.paginacao!.pagina = model.paginacao!.setProximaPagina(
          model.paginacao!.pagina!, model.paginacao!.totalPaginas!);
    }

    try {
      Response responseConsulta = await EquipamentoService.buscar(model);

      if (responseConsulta.statusCode == 200) {
        if (responseConsulta.data['ativos'].isNotEmpty) {
          _updateModelFromResponse(model, responseConsulta);
        } else {
          return Generic.snackBar(
              context: context,
              mensagem: "Não foi encontrado nenhum equipamento",
              tipo: AppName.info);
        }

        return;
      }
      _tratarErro(context, responseConsulta);
    } catch (e) {
      Generic.snackBar(
        context: context,
        mensagem: "Erro inesperado:",
      );
    }
  }

  void _updateModelFromResponse(EquipamentoViewModel model, Response response) {
    var itensEquipamentoModel = ItensEquipamentoModels.fromJson(response.data);
    model.itensEquipamentoModels.equipamentos
        .addAll(itensEquipamentoModel.equipamentos);
    model.paginacao = itensEquipamentoModel.paginacao;
  }

  Future<void> verificarEquipamento(
      BuildContext context, EquipamentoVerificadoViewmodel model) async {
    await _verificarConexao(context);

    try {
      Response responseConsulta =
          await EquipamentoService.verificarEquipamentos(model);

      if (responseConsulta.statusCode == 200) {
        return;
      }
      _tratarErro(context, responseConsulta);
    } catch (e) {
      Generic.snackBar(
        context: context,
        mensagem: "Erro inesperado:",
      );
    }
  }

  Future<void> movimentarEquipamento(
      BuildContext context, EquipamentoVerificadoViewmodel model) async {
    await _verificarConexao(context);

    try {
      FormData formData = FormData.fromMap({
        'idUnidadeAdministrativa': model.idUnidadeAdministrativa,
        'idEquipamento': model.idEquipamento,
        'descricao': model.descricao,
      });

      Response responseConsulta =
          await EquipamentoService.movimentarEquipamentos(formData);

      if (responseConsulta.statusCode == 200) {
        return;
      }
      _tratarErro(context, responseConsulta);
    } catch (e) {
      Generic.snackBar(
        context: context,
        mensagem: "Erro inesperado:",
      );
    }
  }

  Future<void> buscarEquipamentoPorId(
      BuildContext context, ItemEquipamento model) async {
    await _verificarConexao(context);

    try {
      Response response = await EquipamentoService.buscarPorId(model);

      if (response.statusCode != 200) {
        _tratarErro(context, response);
        return;
      }

      EquipamentoModel equipamentoModel =
          EquipamentoModel.fromJson(response.data["detalhes"]);

      context.push(AppRouterName.detalhesEquipamento, extra: equipamentoModel);
    } catch (e) {
      Generic.snackBar(
        context: context,
        mensagem: "Erro inesperado: $e",
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
