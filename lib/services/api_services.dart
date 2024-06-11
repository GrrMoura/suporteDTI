import 'dart:developer' as developer;

class ApiServices {
  //produção
  static const String intranetUrl =
      "https://intranet.ssp.se.gov.br/API/Intranet/";

  static const String suporteDti =
      "https://intranet.ssp.se.gov.br/api/SgiDtiv3/";

  // static const String intranet = "https://intranet.ssp.se.gov.br/api/intranet/";

  //DESENVOLVIMENTO
  // static const String intranetUrl = "http://10.10.2.10/Api/intranet/";

  // static const String suporteDti = "http://intradev.ssp.gov-se/api/SgiDtiv3/";

//
  static String concatIntranetUrl(String url) {
    developer.log("", name: "Serviço de API");

    return intranetUrl + url;
  }

  static String concatDelegaciasUrl(String url) => intranetUrl + url;

  static String concatConsultaIntegradaUrl(String url) => suporteDti + url;
}
