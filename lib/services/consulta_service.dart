import 'package:dio/dio.dart';
import 'package:suporte_dti/model/itens_equipamento_model.dart';
import 'package:suporte_dti/services/api_services.dart';
import 'package:suporte_dti/services/autenticacao_service.dart';
import 'package:suporte_dti/services/requests_services.dart';
import 'package:suporte_dti/viewModel/equipamento_view_model.dart';

class ConsultaService {
  static Future<Response> buscarEquipamentos(EquipamentoViewModel model) async {
    var url =
        ApiServices.concatConsultaIntegradaUrl("Equipamentos/Cadastrados");

    var options = await AutenticacaoService.getCabecalhoRequisicao();

    var responseConsulta = await RequestsServices.postOptions(
        url: url, data: model.toJson(), options: options);

    return responseConsulta;
  }

  static Future<Response> consultaEquipamentoPorId(
      ItemEquipamento model) async {
    var url = ApiServices.concatConsultaIntegradaUrl(
        "IdentificacoesCriminais/Detalhes");

    var options = await AutenticacaoService.getCabecalhoRequisicao();

    var response = await RequestsServices.postOptions(
        url: url, data: model.toJsonOnlyId(), options: options);

    return response;
  }
}
