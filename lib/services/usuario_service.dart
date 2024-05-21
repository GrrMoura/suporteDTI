import 'package:dio/dio.dart';
import 'package:suporte_dti/services/api_services.dart';
import 'package:suporte_dti/services/autenticacao_service.dart';
import 'package:suporte_dti/services/dispositivo_service.dart';
import 'package:suporte_dti/services/requests_services.dart';
import 'package:suporte_dti/model/dispositivo_model.dart';
import 'package:suporte_dti/viewModel/resetar_senha_view_model.dart';

class UsuarioService {
  static Future<Response> resetarSenha(
      ResetarSenhaViewModel resetarSenhaViewModel) async {
    DispositivoModels dispositivo =
        await DispositivoServices.carregarInformacoesDispositivo();
    if (dispositivo.idDispositivo == null) {
      return Response(
          statusCode: 403,
          statusMessage:
              "Não foi possível carregar informações do dispositivo.\nPor favor, contate os administradores.",
          requestOptions: RequestOptions(path: ""));
    }
    var url = ApiServices.concatIntranetUrl("Usuarios/RecuperarSenha");

    // Montagem do cabeçalho com informações do dispositivo
    var options = Options(
        headers: {dispositivo.getHeader(): dispositivo.getHeaderData()});

    var response = await RequestsServices.postOptions(
        url: url, data: resetarSenhaViewModel.toJson(), options: options);
    return response;
  }

  static Future<Response> pegarDadosDoUsuario() async {
    var options = await AutenticacaoService.getCabecalhoRequisicao();
    var url =
        ApiServices.concatIntranetUrl("Usuarios/DadosUsuarioOnlineMobile");

    var response = await RequestsServices.get(url, options);
    return response;
  }
}
