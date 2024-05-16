import 'package:dio/dio.dart';
import 'package:suporte_dti/services/api_services.dart';
import 'package:suporte_dti/services/autenticacao_service.dart';
import 'package:suporte_dti/services/requests_services.dart';
import 'package:suporte_dti/viewModel/equipamento_view_model.dart';

class ConsultaService {
  static Future<Response> consulta(EquipamentoViewModel model) async {
    var url =
        ApiServices.concatConsultaIntegradaUrl("Equipamentos/Cadastrados");

    var options = await AutenticacaoService.getCabecalhoRequisicao();

    var responseConsulta =
        await RequestsServices.postOptions(url, model.toJson(), options);

    return responseConsulta;
  }
}
