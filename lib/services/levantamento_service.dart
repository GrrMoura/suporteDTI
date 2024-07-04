import 'package:dio/dio.dart';
import 'package:suporte_dti/model/levantamento_model.dart';
import 'package:suporte_dti/services/api_services.dart';
import 'package:suporte_dti/services/autenticacao_service.dart';
import 'package:suporte_dti/services/requests_services.dart';

class LevantamentoService {
  static Future<Response> cadastrar(LevantamentoModel model) async {
    var url = ApiServices.concatSGIUrl("Levantamentos/Cadastrar");
    var options = await AutenticacaoService.getCabecalhoRequisicao();
    var response = await RequestsServices.postOptions(
      url: url,
      data: model.toJson(),
      options: options,
    );
    return response;
  }

  static Future<Response> verificarEquipamento(LevantamentoModel model) async {
    var url =
        ApiServices.concatSGIUrl("Levantamentos/VerificarEquipamentosAlocados");
    var options = await AutenticacaoService.getCabecalhoRequisicao();
    var response = await RequestsServices.postOptions(
      url: url,
      data: model.toJson(),
      options: options,
    );
    return response;
  }

  static Future<Response> buscarLevantamentoPorIdUnidade(
      LevantamentoModel model) async {
    var url = ApiServices.concatSGIUrl("Levantamentos/Cadastrados");
    var options = await AutenticacaoService.getCabecalhoRequisicao();
    var response = await RequestsServices.postOptions(
      url: url,
      data: model.toJson(),
      options: options,
    );
    return response;
  }
}
