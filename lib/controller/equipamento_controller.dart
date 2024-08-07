// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suporte_dti/model/equipamento_model.dart';
import 'package:suporte_dti/viewModel/equipamento_nao_alocados.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/model/levantamento_model.dart';
import 'package:suporte_dti/navegacao/app_screens_path.dart';
import 'package:suporte_dti/services/equipamento_service.dart';
import 'package:suporte_dti/services/dispositivo_service.dart';
import 'package:suporte_dti/utils/app_name.dart';
import 'package:suporte_dti/utils/snack_bar_generic.dart';
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
      debugPrint("$e");
    }
  }

  void _updateModelFromResponse(EquipamentoViewModel model, Response response) {
    var itensEquipamentoModel = ItensEquipamentoModels.fromJson(response.data);
    model.itensEquipamentoModels.equipamentos
        .addAll(itensEquipamentoModel.equipamentos);
    model.paginacao = itensEquipamentoModel.paginacao;
  }

  Future<List<NaoAlocado>> verificarEquipamento(
      BuildContext context, LevantamentoModel model) async {
    await _verificarConexao(context);

    try {
      Response responseConsulta =
          await EquipamentoService.verificarEquipamentos(model);

      if (responseConsulta.statusCode == 200) {
        if (responseConsulta.data.containsKey('naoAlocados')) {
          return NaoAlocado.listFromJson(responseConsulta.data['naoAlocados']);
        }
      }

      _tratarErro(context, responseConsulta);
      return [];
    } catch (e) {
      debugPrint("$e");
      return [];
    }
  }

  Future<int> movimentarEquipamento({
    required BuildContext context,
    required String descricao,
    required int idUnidade,
    required int idEquipamento,
  }) async {
    await _verificarConexao(context);

    try {
      FormData formData = FormData.fromMap({
        'idUnidadeAdministrativa': idUnidade,
        'idEquipamento': idEquipamento,
        'descricao': descricao
      });

      Response responseConsulta =
          await EquipamentoService.movimentarEquipamentos(formData);

      if (responseConsulta.statusCode == 200) {
        return 200;
      }
      _tratarErro(context, responseConsulta);
      return 0;
    } catch (e) {
      debugPrint("$e");
      return 0;
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
      debugPrint("$e");
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
        } else {
          mensagemErro = response.data;
        }
      }
      return Generic.snackBar(context: context, mensagem: mensagemErro);
    }
  }
}
