import 'package:dio/dio.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/model/levantamento_model.dart';
import 'package:suporte_dti/services/api_services.dart';
import 'package:suporte_dti/services/autenticacao_service.dart';
import 'package:suporte_dti/services/requests_services.dart';
import 'package:suporte_dti/viewModel/equipamento_verificado_view_model.dart';
import 'package:suporte_dti/viewModel/equipamento_view_model.dart';

class EquipamentoService {
  static Future<Response> buscar(EquipamentoViewModel model) async {
    var url = ApiServices.concatSGIUrl("Equipamentos/Ativos");

    var options = await AutenticacaoService.getCabecalhoRequisicao();

    var responseConsulta = await RequestsServices.postOptions(
        url: url, data: model.toJsonTeste(), options: options);

    return responseConsulta;
  }

  static Future<Response> buscarPorId(ItemEquipamento model) async {
    var url = ApiServices.concatSGIUrl("Equipamentos/Detalhes");

    var options = await AutenticacaoService.getCabecalhoRequisicao();

    var response = await RequestsServices.postOptions(
        url: url, data: model.toJsonOnlyId(), options: options);

    return response;
  }

  static Future<Response> verificarEquipamentos(LevantamentoModel model) async {
    var url =
        ApiServices.concatSGIUrl("Levantamentos/VerificarEquipamentosAlocados");

    var options = await AutenticacaoService.getCabecalhoRequisicao();

    var responseConsulta = await RequestsServices.postOptions(
        url: url, data: model.toJsonVerificar(), options: options);

    return responseConsulta;
  }

  static Future<Response> movimentarEquipamentos(FormData formData) async {
    var url = ApiServices.concatSGIUrl("Equipamentos/Movimentar");

    var options = await AutenticacaoService.getCabecalhoRequisicao();

    var responseConsulta = await RequestsServices.postOptions(
        url: url, data: formData, options: options);

    return responseConsulta;
  }
}
