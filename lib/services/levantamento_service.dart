import 'package:dio/dio.dart';
import 'package:suporte_dti/services/api_services.dart';
import 'package:suporte_dti/services/autenticacao_service.dart';
import 'package:suporte_dti/services/requests_services.dart';
import 'package:suporte_dti/viewModel/delegacias_view_model.dart';

class LevantamentoService {
  static Future<Response> cadastrar(DelegaciasViewModel model) async {
    var url = ApiServices.concatDelegaciasUrl("Levantamentos/Cadastrar");

    var options = await AutenticacaoService.getCabecalhoRequisicao();

    var responseConsulta = await RequestsServices.postOptions(
        url: url, data: model.toJson(), options: options);

    return responseConsulta;
  }
}
