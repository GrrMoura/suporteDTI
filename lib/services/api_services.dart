import 'dart:developer' as developer;

class ApiServices {
  //produção
  static const String intranetUrl =
      "https://intranet.ssp.se.gov.br/API/Intranet/";
  // static const String suporteDti =
  //     "https://intranet.ssp.se.gov.br/API/sgi/dti/v3";

  // static const String suporteDti =
  //     "https://intranet.ssp.se.gov.br/API/sgi/dti/v3/sGIDTI/";

  static const String suporteDti =
      "https://intranet.ssp.se.gov.br/api/SgiDtiv3/";

  static const String intranet = "https://intranet.ssp.se.gov.br/api/intranet/";

  static String concatIntranetUrl(String url) {
    developer.log("", name: "Serviço de API");

    return intranetUrl + url;
  }

  static String concatDelegaciasUrl(String url) => intranet + url;

  static String concatConsultaIntegradaUrl(String url) => suporteDti + url;
}
