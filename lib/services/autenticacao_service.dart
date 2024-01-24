import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suporte_dti/model/sessao_model.dart';
import 'package:suporte_dti/services/api_services.dart';
import 'package:suporte_dti/services/dispositivo_service.dart';
import 'package:suporte_dti/services/requests_services.dart';
import 'package:suporte_dti/utils/configuracoes_global_utils.dart';
import 'package:suporte_dti/viewModel/dispositivo_view_model.dart';
import 'package:suporte_dti/viewModel/login_view_model.dart';

class AutenticacaoService {
  static Future<Response> logar(LoginViewModel loginViewModel) async {
    var dispositivo =
        await DispositivoServices.carregarInformacoesDispositivo();
    if (dispositivo.so == null) {
      return Response(
          statusCode: 403,
          statusMessage:
              "Não foi possível carregar informações do dispositivo.\nPor favor, contate os administradores.",
          requestOptions: RequestOptions(path: ""));
    }

    // Montagem do cabeçalho com informações do dispositivo
    var options = Options(
        headers: {dispositivo.getHeader(): dispositivo.getHeaderData()});

    // Iniciar Sessao do aplicativo
    var responseSessaoIniciar = await iniciarSessao(loginViewModel, options);
    if (responseSessaoIniciar.statusCode != 200) {
      return responseSessaoIniciar;
    }

    var sessao = Sessao.fromJson(responseSessaoIniciar.data);
    options.headers!.addAll({"Authorization": "Basic ${sessao.token}"});

    // Verificar se usuário pode acessar o sistema
    var responseSessaoAcessoAoSistema = await acessarSistema(options);

    return responseSessaoAcessoAoSistema.statusCode == 200
        ? responseSessaoIniciar
        : responseSessaoAcessoAoSistema;
  }

  static Future<Response> iniciarSessao(
      LoginViewModel loginViewModel, Options options) async {
    var url = ApiServices.concatIntranetUrl("Sessoes/Iniciar");

    var responseIniciarSessao = await RequestsServices.postOptions(
        url, loginViewModel.toJson(), options);

    return responseIniciarSessao;
  }

  static Future<Response> acessarSistema(Options options) async {
    var url = ApiServices.concatIntranetUrl("Sessoes/AcessarSistema");

    final Map<String, dynamic> data = <String, dynamic>{};
    data['IdSistema'] = ConfiguracoesGlobalUtils.ID_SISTEMA;

    var responseIniciarSessao =
        await RequestsServices.postOptions(url, data, options);

    return responseIniciarSessao;
  }

  static Future<Options> getCabecalhoRequisicao() async {
    // Montagem do cabeçalho com informações do dispositivo
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = Sessao.getSession(prefs).token;

    var options = Options(
        headers: {"MobileInformation": ConfiguracoesGlobalUtils.ID_SISTEMA});
    options.headers!.addAll({"Authorization": "Basic $token"});
    return options;
  }

  // static Future<Map<String, String>> getHeader() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var token = Sessao.getSession(prefs).token;

  //   var header = {
  //     "Content-Type": "application/json; charset=UTF-8",
  //     dispositivo.getHeader(): dispositivo.getHeaderData(),
  //     "Authorization": "Basic $token"
  //   };
  //   return header;
  // }

  static Future<Response> encerrarSessao() async {
    var url = ApiServices.concatIntranetUrl("Sessoes/Encerrar");

    var options = await getCabecalhoRequisicao();

    var responseEncerrarSessao =
        await RequestsServices.postOptions(url, null, options);

    return responseEncerrarSessao;
  }
}
